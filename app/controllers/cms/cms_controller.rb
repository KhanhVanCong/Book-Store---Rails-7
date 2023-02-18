# frozen_string_literal: true
class Cms::CmsController < ApplicationController
  before_action :authenticate_cms_admin!
  before_action :handle_admin_banned

  layout "cms"

  private

    def handle_admin_banned
      if current_cms_admin.status_inactive?
        sign_out current_cms_admin
        redirect_to cms_login_url, alert: "User is inactive. Please contact admin to resolve it."
      end
    end
end
