# frozen_string_literal: true

class ChangeColumnsAddNotnullOnStatuses < ActiveRecord::Migration[5.2]
  def change
    change_column_null :statuses, :name, false
  end
end
