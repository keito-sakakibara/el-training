class TaskLabelRelationship < ApplicationRecord
  belongs_to :task
  belongs_to :label
end
