class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :items

  def self.partial_name_search(search)
    Merchant.where("name ILIKE ?", "%#{search}%")
  end
end