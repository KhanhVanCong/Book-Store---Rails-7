require "rails_helper"

RSpec.describe "Cart", type: :request do
  describe "Add item to user cart" do
    context "when the user does not login" do
      it "will fail" do
        add_item_to_cart(10)
        expect(response).to have_http_status(:found)
      end
    end

    context "when the use login" do
      it "will succeeded" do
        login(user.email, user.password)
        expect(response).to have_http_status(:redirect)
        expect {
          add_item_to_cart(book.id)
          expect(response).to have_http_status(:ok)
        }.to change { user.cart.cart_items.count }.by(1)
        book_is_added_to_cart = user.cart.books.last
        expect(book_is_added_to_cart).to eq book
      end
    end
  end
end