require "rails_helper"

RSpec.describe "Authentications", type: :request do
  describe "Signup" do
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

    context "with valid params" do
      it "is successful" do
        expect { create_user("khanh", "van", "khanh@test111.com", "Qwett@7281723", "Qwett@7281723") }
          .to change { User.count }.from(0).to(1)
        expect(response).to have_http_status(:redirect)
      end
    end

    context "with invalid params" do
      it "fails at creating the user with empty first name" do
        expect { create_user("", "van", "khanh@test111.com", "Qwett@7281723", "Qwett@7281723") }
          .not_to change { User.count }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "fails at creating the user with empty last name" do
        expect { create_user("dfa", "", "khanh@test111.com", "Qwett@7281723", "Qwett@7281723") }
          .not_to change { User.count }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "fails at creating the user with wrong email" do
        expect { create_user("khanh", "van", "skk", "Qwett@7281723", "Qwett@7281723") }
          .not_to change { User.count }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "fails at creating the user with password and password confirmation not match" do
        expect { create_user("khanh", "van", "khanh@test.com", "Qwett@", "Qwett@7281723") }
          .not_to change { User.count }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "fails at creating the user with password too short" do
        expect { create_user("khanh", "van", "khanh@test.com", "Qwett@", "Qwett@") }
          .not_to change { User.count }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end