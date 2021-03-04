# frozen_string_literal: true

class ChangeColumnsAddNotnullOnPriorities < ActiveRecord::Migration[5.2]
  def change
    change_column_null :priorities, :name, false
  end
end
