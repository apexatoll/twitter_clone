module ApplicationHelper
  def full_title(page)
    base = "RoR Twitter Clone"
    page.empty? ? base : [page, base].join(" | ")
  end
end
