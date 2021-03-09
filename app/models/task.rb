# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :status
  belongs_to :priority
  validates :name, presence: true
end
