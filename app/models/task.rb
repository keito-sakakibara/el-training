# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :status
  belongs_to :priority
  belongs_to :user
  validates :name, presence: true
end
