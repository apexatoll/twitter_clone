module ApplicationHelper
  def full_title(page)
    base = "RoR Sample App"
    page.empty? ? base : [page, base].join(" | ")
  end
end
