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
      tag = create_list(:tag, 1)
      category = create_list(:category, 1)
      author = create_list(:author, 1)
      book.tags << tag
      book.categories << category
      book.authors << author
    end
  end
end
