class ApplicationController < ActionController::Base
  layout :layout_by_resource

  protected

    def devise_parameter_sanitizer
      if resource_class == User
        User::ParameterSanitizer.new(User, :user, params)
      else
        super # Use the default one
      end
    end

    def layout_by_resource
      if devise_controller?
        "authentication"
      else
        "application"
      end
    end
end