class Task < ApplicationRecord
  belongs_to :project
  has_many :task_times, dependent: :delete_all

  scope :order_by_company_project_and_task, -> {
    joins(project: :company).order('companies.name, projects.name, tasks.name')
  }

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :project_id
end
