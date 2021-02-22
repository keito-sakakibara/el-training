# frozen_string_literal: true

class AddDeadlineAtToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :deadline_date, :date
  end
end
