require "rails_helper"

RSpec.describe "Cart", type: :request do
  describe "Remove item to user cart" do
    let(:user) { create(:user) }
    let(:book) { create(:book) }

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

    def remove_item_to_cart(book_id)
      delete cart_path, params: {
        cart: {
          book_id: book_id
        }
      }
    end

    context "when the user does not login" do
      it "will fail" do
        remove_item_to_cart(10)
        expect(response).to have_http_status(:found)
      end
    end

    context "when the use login" do
      it "will succeeded" do
        login(user.email, user.password)
        expect(response).to have_http_status(:redirect)
        add_item_to_cart(book.id)
        expect(response).to have_http_status(:ok)
        expect(user.cart.orders.count).to eq 1
        remove_item_to_cart(book.id)
        expect(response).to have_http_status(:ok)
        expect(user.cart.orders.count).to eq 0
      end
    end
  end
end