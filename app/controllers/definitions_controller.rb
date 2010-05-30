require 'lingua/stemmer'

class DefinitionsController < ApplicationController
  def show
    @original_word = @word = params[:id]

    @definitions = Wordnik.definitions(@word)

    # if there were no definitions from the original input, try the singular of it
    if @definitions.empty?
      @word = @word.singularize
      @definitions = Wordnik.definitions(@word)
    end

    # if there were no definitions found yet, try definitions for the stem
    if @definitions.empty?
      @word = Lingua::Stemmer.new.stem(@word)
      @definitions = Wordnik.definitions(@word)
    end
    @definitions.reject! {|d| d.text.blank? }

    @word = @original_word if @definitions.empty? # if we didnt find anything just use the original word when displaying results

    # find wikipedia articles for the word
    @article_title, @wiki_html = Wikipedia.download(@original_word)
#    if !wikipedia_response.blank?
#      @wiki_html = WikiCloth::WikiCloth.new({:data => wikipedia_response, :link_handler => WikipediaLinkHandler.new}).to_html.force_encoding("ascii-8bit").html_safe
#    end
    #ascii-8bit
    @wiki_html = @wiki_html.force_encoding("UTF-8").html_safe

    respond_to do |format|
      format.js { render }
    end
  end
end
