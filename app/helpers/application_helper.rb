module ApplicationHelper
    def page_title(title)
       title += " | " if title.present?
       title += "Revolution"
    end
end
