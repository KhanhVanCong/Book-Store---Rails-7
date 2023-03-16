# frozen_string_literal: true
module Cms
  class AttachmentsController < CmsController
    def purge
      attachment = ActiveStorage::Attachment.find(params[:id])
      attachment.purge
      redirect_back(fallback_location: cms_books_path, notice: "success")
    end
  end
end

