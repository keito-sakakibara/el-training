# frozen_string_literal: true

class Task < ApplicationRecord
  has_many :task_label_relationships
  has_many :labels, through: :task_label_relationships
  belongs_to :status
  belongs_to :priority
  belongs_to :user
  counter_culture :user
  validates :name, presence: true
end
