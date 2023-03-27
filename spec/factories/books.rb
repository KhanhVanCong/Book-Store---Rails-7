FactoryBot.define do
  factory :book do
    title { "Book 1" }
    description { "This is a test book" }
    price { 1.0 }
    is_featured { false }

    before(:create) do |book|
      book.images.attach(
        io: File.open(Rails.root.join('spec', 'files', 'images', 'book_image.jpg')),
        filename: 'book_image.jpg',
        content_type: 'image/jpeg'
      )
      tag = Tag.first.blank? ? create(:tag) : Tag.first
      category = Category.first.blank? ? create(:category) : Category.first
      author = Author.first.blank? ? create(:author) : Author.first
      book.tags << tag
      book.categories << category
      book.authors << author
    end
  end
end
