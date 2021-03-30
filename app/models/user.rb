# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  validates :name, presence: true
  has_secure_password

  before_destroy :leave_at_least_one_admin_user

  def leave_at_least_one_admin_user
    unless User.where(is_admin: true).count > 1
      errors.add(:is_admin, 'は最低1人必要です')
      throw(:abort)
    end
  end
end
