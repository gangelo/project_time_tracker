class AddDefaultValueToTaskTimeDuration < ActiveRecord::Migration[5.1]
  def change
    change_column :task_times, :duration, :integer, default: 0, null: false
  end
end
