module AuthHelper
  def login(email, password)
    post login_path, params: {
      user: {
        email: email,
        password: password,
      }
    }
  end
end
