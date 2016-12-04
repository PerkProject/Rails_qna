# frozen_string_literal: true
class AttachmentsController < ApplicationController
  before_action :find_attachment, only: [:destroy]

  def destroy
    @attachment.destroy if current_user.check_owner(@attachment.attachable)
    redirect_back(fallback_location: (request.referer || root_path))
  end

  private

  def find_attachment
    @attachment = Attachment.find(attachment_params)
  end

  def attachment_params
    params.require(:id)
  end
end
