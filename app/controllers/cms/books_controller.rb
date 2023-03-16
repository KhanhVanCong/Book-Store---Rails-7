# frozen_string_literal: true

module Cms
  class BooksController < CmsController
    before_action :find_book, only: %i[ edit update destroy pure_image ]

    # GET /cms/books
    def index
      @pagy, @books = pagy(Book.all)
    end

    # GET /cms/books/new
    def new
      @book = Book.new
    end

    # GET /cms/books/1/edit
    def edit
    end

    # POST /cms/books
    def create
      @book = Book.new(book_params)
      set_images
      if @book.save
        redirect_to cms_books_path, notice: "Book was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /cms/books/1
    def update
      set_images
      if @book.update(book_params)
        redirect_to cms_books_path, notice: "Book was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /cms/books/1
    def destroy
      @book.destroy
      redirect_to cms_books_url, notice: "Book was successfully destroyed."
    end

    def pure_image
      if @book.images.count > 1
        image = @book.images.find_by(id: params.dig(:image_id))
        image.purge
        redirect_back(fallback_location: root_path, notice: "Book's image was successfully destroyed.")
      else
        @book.errors.add(:images, message: "need to at least one image for book")
        render :edit, status: :unprocessable_entity
      end
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def find_book
        @book = Book.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def book_params
        params.require(:book).permit(:title, :description, :price, author_ids: [], tag_ids: [], category_ids: [])
      end

      def set_images
        images = params.dig(:book, :images)
        @book.images.attach(images) if images
      end
  end
end

