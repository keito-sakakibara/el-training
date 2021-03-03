# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :status
  validates :name, presence: true
end
