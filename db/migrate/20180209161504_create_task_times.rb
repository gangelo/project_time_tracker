class CreateTaskTimes < ActiveRecord::Migration[5.1]
  def change
    create_table :task_times do |t|
      t.integer :duration
      t.datetime :start_time
      t.string :note
      t.references :task, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
