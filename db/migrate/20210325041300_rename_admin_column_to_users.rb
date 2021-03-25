class RenameAdminColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :admin, :is_admin
  end
end
