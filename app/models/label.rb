class Label < ApplicationRecord
  has_many :task_label_relationships
  has_many :tasks, through: :task_label_relationships
end
