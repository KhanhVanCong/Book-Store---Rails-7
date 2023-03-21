require "rails_helper"

RSpec.describe "Cart", type: :request do
  describe "show all items" do
    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:book2) { create(:book) }

    def login(email, password)
      post login_path, params: {
        user: {
          email: email,
          password: password,
        }
      }
    end

    def add_item_to_cart(book_id)
      post cart_path, params: {
        cart: {
          book_id: book_id
        }
      }
    end

    def get_cart
      get cart_path
    end

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
        add_item_to_cart(book.id)
        expect(response).to have_http_status(:ok)
        add_item_to_cart(book2.id)
        expect(response).to have_http_status(:ok)
        expect(user.cart.orders.count).to eq 2
        get_cart()
        books = assigns(:books)
        total_price = assigns(:total_price)
        expect(response).to have_http_status(:ok)
        expect(books.count).to eq 2
        expect(total_price).to eq 2.0
      end
    end
  end
end