FactoryBot.define do
  factory :author do
    first_name { "Khanh" }
    last_name { "Khanh" }
    description { "this is a author" }
    facebook_link { "https://facebook.com/" }
    instagram_link { "https://www.instagram.com/" }
    google_plus_link { "https://google.com" }
    twitter_link { "https://twitter.com/" }

    before(:create) do |author|
      author.avatar.attach(
        io: File.open(Rails.root.join('spec', 'files', 'images', 'author_avatar.jpg')),
        filename: 'author_avatar.jpg',
        content_type: 'image/jpeg'
      )
    end
  end
end
