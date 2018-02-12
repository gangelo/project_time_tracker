class Project < ApplicationRecord
  belongs_to :company
  has_many :tasks, dependent: :delete_all
end
