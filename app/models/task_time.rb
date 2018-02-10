class TaskTime < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates :note, length: { maximum: 128,
    too_long: "Note must be less than or equal to %{count} characters" }, allow_blank: true

  validates_numericality_of :duration, message: "must be numeric"
end
