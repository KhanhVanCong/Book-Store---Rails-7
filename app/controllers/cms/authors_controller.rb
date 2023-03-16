# frozen_string_literal: true
module Cms
  class AuthorsController < CmsController
    before_action :find_author, only: %i[ edit update destroy ]

    # GET /cms/authors
    def index
      @pagy, @authors = pagy(Author.all)
    end

    # GET /cms/authors/new
    def new
      @author = Author.new
    end

    # GET /cms/authors/1/edit
    def edit
    end

    # POST /cms/authors
    def create
      @author = Author.new(author_params)
      if @author.save
        redirect_to cms_authors_path, notice: "author was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /cms/authors/1
    def update
      if @author.update(author_params)
        redirect_to cms_authors_path, notice: "author was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /cms/authors/1
    def destroy
      @author.destroy
      redirect_to cms_authors_url, notice: "author was successfully destroyed."
    rescue => e
      redirect_to cms_authors_url, notice: e.message
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def find_author
        @author = Author.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def author_params
        params.require(:author).permit(:first_name, :last_name,
                                       :description, :facebook_link,
                                       :instagram_link, :google_plus_link,
                                       :twitter_link, :avatar)
      end
  end
end
