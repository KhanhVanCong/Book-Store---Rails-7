module Cms
  class AdminsController < CmsController
    before_action :set_cms_admin, only: %i[ show edit update destroy ]

    # GET /cms/admins
    def index
      @pagy, @cms_admins = pagy(Admin.all)
    end

    # GET /cms/admins/new
    def new
      @cms_admin = Admin.new
    end

    # GET /cms/admins/1/edit
    def edit
    end

    # POST /cms/admins
    def create
      @cms_admin = Admin.new(cms_admin_params)

      if @cms_admin.save
        redirect_to cms_admins_path, notice: "Admin was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /cms/admins/1
    def update
      begin
        filtered_admin_params = cms_admin_params
        filtered_admin_params.delete(:password) if cms_admin_params[:password].blank?
        @cms_admin.update!(filtered_admin_params)
        redirect_to cms_admins_path, notice: "Admin was successfully updated."
      rescue => e
        flash.now.alert = e&.message
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /cms/admins/1
    def destroy
      if can_delete_admin_user? && @cms_admin.destroy
        flash.notice = "Admin was successfully destroyed."
      else
        flash.alert = CustomExceptions::AtLeastOneSuperAdmin.new().message
      end

      redirect_to cms_admins_url
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_cms_admin
        @cms_admin = Admin.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def cms_admin_params
        params.require(:admin).permit(:name, :status, :role, :password, :email)
      end

      def can_delete_admin_user?
        current_cms_admin.super_admin? && @cms_admin.is_not_current_admin?(current_cms_admin)
      end
  end
end
