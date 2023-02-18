class Devise::AuthenticationFailure < Devise::FailureApp
  def route(scope)
    scope.to_sym == :cms_admin ? :cms_login_url : super
  end
end