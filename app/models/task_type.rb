class TaskType < ApplicationRecord
    has_many :tasks, dependent: :destroy
    
    validates_presence_of :name
end
