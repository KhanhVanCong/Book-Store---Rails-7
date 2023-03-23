require "rails_helper"

RSpec.describe "Cart", type: :request do
  describe "empty" do
    context "when the user does not login" do
      it "will fail" do
        empty_cart()
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
          add_item_to_cart(book2.id)
          expect(response).to have_http_status(:ok)
        }.to change { user.cart.cart_items.count }.by(2)

        cart_item_of_book = user.cart.cart_items.find_by(book_id: book.id)
        cart_item_of_book2 = user.cart.cart_items.find_by(book_id: book2.id)
        expect {
          empty_cart()
          expect(response).to redirect_to(root_path)
        }.to change { user.cart.cart_items.count }.from(2).to(0)
         .and change { CartItem.exists?(id: cart_item_of_book.id) }.from(true).to(false)
         .and change { CartItem.exists?(id: cart_item_of_book2.id) }.from(true).to(false)
      end
    end
  end
end