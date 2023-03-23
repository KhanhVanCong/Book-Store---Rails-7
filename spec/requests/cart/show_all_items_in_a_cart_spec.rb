require "rails_helper"

RSpec.describe "Cart", type: :request do
  describe "show all items" do
    context "when the user does not login" do
      it "will fail" do
        get_cart()
        expect(response).to have_http_status(:found)
      end
    end

    context "when the use login" do
      it "will succeeded" do
        login(user.email, user.password)
        expect(response).to have_http_status(:redirect)

        expect{
          add_item_to_cart(book.id)
          expect(response).to have_http_status(:ok)
          add_item_to_cart(book2.id)
          expect(response).to have_http_status(:ok)
        }.to change {user.cart.cart_items.count}.by(2)

        get_cart()
        books = assigns(:books)
        total_price = assigns(:total_price)
        expect(response).to have_http_status(:ok)
        expect(books.count).to eq 2
        expect(total_price).to eq (book.price + book2.price)
      end
    end
  end
end