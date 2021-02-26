# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :status
  accepts_nested_attributes_for :status
  validates :name, presence: true

  scope :search_status_id, ->(status_id) { where('cast(status_id as text) LIKE ?', "#{status_id}") }
  scope :search_task_name, ->(task_name) { where('name LIKE ?', "#{task_name}")}
end
