class AddTaskTypeToTasks < ActiveRecord::Migration[5.0]
  def change
    add_reference :tasks, :task_type, foreign_key: true
  end
end
