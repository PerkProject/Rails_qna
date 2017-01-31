class SearchController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @results = Search.find(params[:query], params[:object])
    respond_with(@results)
  end
end
