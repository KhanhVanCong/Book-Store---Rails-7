require "rails_helper"

RSpec.describe "Authentications", type: :request do
  describe "Resend confirmation" do
    let(:user) { create(:user) }
    def create_user(first_name, last_name, email, password, password_confirmation)

      post sign_up_path, params: {
        user: {
          first_name: first_name,
          last_name: last_name,
          email: email,
          password: password,
          password_confirmation: password_confirmation
        }
      }
    end

    def resend_confirmation(email)
      post user_confirmation_path, params: {
        user: {
          email: email
        }
      }
    end

    context "with exist email" do
      it "is successful at account which is not confirmed" do
        create_user("khanh", "van", "test@blabla.com", "Poeoweo@1231", "Poeoweo@1231")
        resend_confirmation("test@blabla.com")
        expect(response).to have_http_status(:found)
      end

      it "fails at account which is confirmed" do
        resend_confirmation(user.email)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end