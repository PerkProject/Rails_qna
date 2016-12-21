# frozen_string_literal: true
class AttachmentsController < ApplicationController
  before_action :find_attachment, only: [:destroy]
  before_action :set_attachable, only: [:destroy]

  respond_to :js

  def destroy
    respond_with(@attachment.destroy) if current_user.check_owner(@attachment.attachable)
  end

  private

  def find_attachment
    @attachment = Attachment.find(attachment_params)
  end

  def set_attachable
    @attachable = @attachment.attachable
  end

  def attachment_params
    params.require(:id)
  end
end
