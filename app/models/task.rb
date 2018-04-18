class Task < ApplicationRecord
  belongs_to :user
  belongs_to :task_type

  validates_presence_of :title, :user_id, :task_type_id
end
