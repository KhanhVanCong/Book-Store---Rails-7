# frozen_string_literal: true
module Cms
  class CategoriesController < CmsController
    before_action :find_category, only: %i[ edit update destroy ]

    def index
      @pagy, @categories = pagy(Category.all)
    end

    def new
      @category = Category.new
    end

    def edit
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to cms_categories_path, notice: "category was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @category.update(category_params)
        redirect_to cms_categories_path, notice: "category was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @category.destroy
      redirect_to cms_categories_url, notice: "category was successfully destroyed."
    rescue => e
      redirect_to cms_categories_path, notice: e.message
    end

    private
      def find_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name)
      end
  end
end

