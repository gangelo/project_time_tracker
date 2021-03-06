class Company < ApplicationRecord
  has_many :projects, dependent: :delete_all

  validates_presence_of :name
  validates_uniqueness_of :name
end
