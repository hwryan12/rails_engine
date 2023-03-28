class Invoice < ApplicationRecord
  validates_presence_of :customer_id, :merchant_id, :status
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items, dependent: :delete_all
  has_many :items, through: :invoice_items
end