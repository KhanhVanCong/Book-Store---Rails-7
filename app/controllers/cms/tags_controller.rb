# frozen_string_literal: true
module Cms
  class TagsController < CmsController
    before_action :find_tag, only: %i[ edit update destroy ]

    # GET /cms/tags
    def index
      @pagy, @tags = pagy(Tag.all)
    end

    # GET /cms/tags/new
    def new
      @tag = Tag.new
    end

    # GET /cms/tags/1/edit
    def edit
    end

    # POST /cms/tags
    def create
      @tag = Tag.new(tag_params)
      if @tag.save
        redirect_to cms_tags_path, notice: "tag was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /cms/tags/1
    def update
      if @tag.update(tag_params)
        redirect_to cms_tags_path, notice: "tag was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /cms/tags/1
    def destroy
      begin
        @tag.destroy
        redirect_to cms_tags_url, notice: "tag was successfully destroyed."
      rescue => e
        redirect_to cms_tags_url, notice: e.message
      end

    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def find_tag
        @tag = Tag.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def tag_params
        params.require(:tag).permit(:name)
      end
  end
end
