require "em-synchrony/em-http"

class DocumentsController < ApplicationController
  def new
    @document = Document.new
  end

  def create
    @document = Document.new(params[:document])
    if @document.save
      redirect_to @document
    else
      render :action => :new
    end
  end

  def show
    @document = Document.find_by_checksum(params[:id])
    # @document.complex_words_sorted_by_syllables.each do |word, num_syllables|
  end

end
