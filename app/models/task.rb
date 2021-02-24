# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :status
  accepts_nested_attributes_for :status
  validates :name, presence: true
end
