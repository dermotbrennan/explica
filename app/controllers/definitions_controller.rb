require 'lingua/stemmer'

class DefinitionsController < ApplicationController
  def show
    @original_word = @word = params[:id]
    @definitions = Wordnik.definitions(@word)
    if @definitions.empty?
      @word = @word.singularize
      @definitions = Wordnik.definitions(@word)
    end
    if @definitions.empty?
      @word = Lingua::Stemmer.new.stem(@word)
      @definitions = Wordnik.definitions(@word)
    end
    @definitions.reject! {|d| d.text.blank? }

    @word = @original_word if @definitions.empty?

    @article_title, wikipedia_response = Wikipedia.download(@original_word, :follow_redirects => true)
    if !wikipedia_response.blank?
      @wiki_html = WikiCloth::WikiCloth.new({:data => wikipedia_response}).to_html.force_encoding("ascii-8bit").html_safe
    end

    respond_to do |format|
      format.js { render }
    end
  end
end
