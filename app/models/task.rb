# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name, presence: true

  # 引数の値がnil,true,falseによって一覧をソート
  # @param [String] params[:deadline_date_sort]
  # return [] 引数がnilの場合created_atを降順
  # return [] 引数のdeadline_date_sortがtrueの場合、deadline＿dateを昇順
  # return [] 引数のdeadline_date_sortがfalseの場合、deadline＿dateを降順
  def self.deadline_sort(sort)
    if sort.nil?
      order(created_at: :desc)
    elsif ActiveRecord::Type::Boolean.new.cast(sort)
      order(deadline_date: :asc)
    else
      order(deadline_date: :desc)
    end
  end
end
