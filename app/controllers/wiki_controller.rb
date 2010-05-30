class WikiController < ApplicationController
  def show
    title = params[:id]
    redirect_to "http://en.wikipedia.org/wiki/#{title}"
  end
end
