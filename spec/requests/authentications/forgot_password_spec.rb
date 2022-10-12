require "rails_helper"

RSpec.describe "Authentications", type: :request do
  describe "Forgot Password" do
    let(:user) { create(:user) }

    def forgot_password(email)
      post forgot_password_path, params: {
        user: {
          email: email
        }
      }
    end

    context "with exist email" do
      it "is successful" do
        forgot_password(user.email)
        expect(response).to have_http_status(:found)
      end
    end

    context "with not exist email" do
      it "fails" do
        forgot_password("not_found@test.com")
        expect(response).to have_http_status(:ok)
      end
    end
  end
end