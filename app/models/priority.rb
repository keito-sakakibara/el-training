class Priority < ApplicationRecord
  validates :name, presence: true
  has_many :tasks
end
