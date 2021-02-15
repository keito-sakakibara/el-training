# frozen_string_literal: true

class ChangeColumnsAddNotnullOnTasks < ActiveRecord::Migration[5.2]
  def change
    change_column_null :tasks, :name, false
  end
end
