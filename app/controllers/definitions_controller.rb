require 'lingua/stemmer'
require 'em-synchrony'
#require "em-synchrony/em-http"

class DefinitionsController < ApplicationController
  def show
    @word = params[:id]

    # run all our api call asynchronously
    multi = EventMachine::Synchrony::Multi.new

    # try a few different variants on the word
    [@word, @word.singularize, Lingua::Stemmer.new.stem(@word)].uniq.each do |word|
      multi.add :"wordnik_#{word}", Wordnik.aget(word)
    end

    # search wikipedia
    multi.add :wikipedia, Wikipedia.aget(@word)

    # do the calls
    @data = multi.perform.responses[:callback]

    # figure out which word gave results from wordnik
    wordnik_keys = @data.keys.select {|k| k =~ /^wordnik/ }
    if !wordnik_keys.empty?
      @definitions = wordnik_keys.collect do |wordnik_key|
        if !(definitions = Wordnik.parse(@data[wordnik_key])).empty?
          @word = wordnik_key.to_s.gsub(/wordnik_/, '') # find the word that had results
          definitions
        else
          nil
        end
      end.compact.first
      @definitions.reject! {|d| d.text.blank? } if @definitions && @definitions.is_a?(Array)
    end

    # parse the results of the wikipedia calls
    @article_title, @wiki_html = Wikipedia.parse(@data[:wikipedia])
    @wiki_html = @wiki_html.force_encoding("UTF-8").html_safe

    respond_to do |format|
      format.js { render }
    end
  end
end
