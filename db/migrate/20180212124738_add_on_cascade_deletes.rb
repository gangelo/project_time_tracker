class AddOnCascadeDeletes < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :projects, :companies
    remove_foreign_key :tasks, :projects
    remove_foreign_key :task_times, :tasks

    add_foreign_key :projects, :companies, on_delete: :cascade
    add_foreign_key :tasks, :projects, on_delete: :cascade
    add_foreign_key :task_times, :tasks, on_delete: :cascade
  end
end
