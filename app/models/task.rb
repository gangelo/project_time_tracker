class Task < ApplicationRecord
  belongs_to :project
  has_many :task_times, dependent: :delete_all
end
