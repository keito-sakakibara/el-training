class CreateTaskLabelRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :task_label_relationships do |t|
      t.references :task, index: true
      t.references :label, index: true
      t.timestamps
    end
  end
end
