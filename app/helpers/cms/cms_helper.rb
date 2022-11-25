module Cms::CmsHelper
  NAME_OF_CLASS_ACTIVE = "active"
  def sidenav_active(name:)
    controller = params[:controller].parameterize
    case name
    when "books"
      NAME_OF_CLASS_ACTIVE if controller == "cms-books"
    when "authors"
      NAME_OF_CLASS_ACTIVE if controller == "cms-authors"
    when "tags"
      NAME_OF_CLASS_ACTIVE if controller == "cms-tags"
    when "categories"
      NAME_OF_CLASS_ACTIVE if controller == "cms-categories"
    end
  end
end
