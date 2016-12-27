class PagesController < ApplicationController

  authorize_resource

  def terms; end

  def policy; end
end
