module Cms::CmsHelper
  def sidenav_active(name:)
    controller = params[:controller].parameterize
    case name
    when "books"
      "active" if controller == "cms-books"
    end
  end
end
