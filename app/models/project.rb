class Project < ApplicationRecord
  belongs_to :company
  has_many :tasks, dependent: :delete_all

  scope :order_by_company_and_project, -> {
    joins(:company).order("companies.name, projects.name")
  }

  validates_presence_of :name
  validates_uniqueness_of :name
end
