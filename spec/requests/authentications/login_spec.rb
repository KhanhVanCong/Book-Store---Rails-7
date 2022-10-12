require "rails_helper"

RSpec.describe "Authentications", type: :request do
  describe "Login" do
    let(:user) { create(:user) }

    def login(email, password)
      post login_path, params: {
        user: {
          email: email,
          password: password,
        }
      }
    end

    context "with valid params" do
      it "is successful" do
        login(user.email, user.password)
        expect(response).to have_http_status(:redirect)
      end
    end

    context "with invalid params" do
      it "fails at incorrect email" do
        login("", user.password)
        expect(response).to have_http_status(:ok)
      end

      it "fails at incorrect password" do
        login(user.email, "")
        expect(response).to have_http_status(:ok)
      end
    end
  end
end