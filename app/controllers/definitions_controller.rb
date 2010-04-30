class DefinitionsController < ApplicationController
  def show
    @word = params[:id]
    @definitions = Wordnik.definitions(@word)
    @definitions.reject! {|d| d.text.blank? }
    respond_to do |format|
      format.js { render }
    end
  end
end
