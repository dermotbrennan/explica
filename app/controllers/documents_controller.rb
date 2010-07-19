require "em-synchrony/em-http"

class DocumentsController < ApplicationController
  def new
    @recent_documents = Document.public.limit(5)
    @sample_doc = Document.public.last
    @document = Document.new
  end

  def index
    @documents = Document.public.paginate(:page => params[:page] || 1, :per_page => params[:per_page] || 100)
  end

  def create
    @document = Document.new(params[:document])
    if @document.save
      redirect_to @document
    else
      @recent_documents = Document.public.limit(5)
      @sample_doc = Document.public.last
      render :action => :new
    end
  end

  def show
    @document = Document.find_by_checksum(params[:id])
    # @document.complex_words_sorted_by_syllables.each do |word, num_syllables|
  end

end
