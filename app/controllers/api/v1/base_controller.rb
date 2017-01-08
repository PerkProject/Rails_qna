class Api::V1::BaseController < ApplicationController
  protected

  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end
end