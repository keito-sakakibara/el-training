# frozen_string_literal: true

class AddPriorityIdToTasks < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks, :priority, foreign_key: true
  end
end
