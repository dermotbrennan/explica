class DefinitionsController < ApplicationController
  def show
    @definition = Definition.find_by_name(params[:id])
    respond_to do |format|
      format.json { @definition.to_json }
    end
  end
end
