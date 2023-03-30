class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.partial_name_search(search)
    self.where("name ILIKE ?", "%#{search}%").order("LOWER(name) ASC")
  end
end
