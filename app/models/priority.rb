# frozen_string_literal: true

class Priority < ApplicationRecord
  validates :name, presence: true
  has_many :tasks
end
