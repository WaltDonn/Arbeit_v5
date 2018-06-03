class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :due_string
      t.datetime :due_on
      t.integer :project_id
      t.integer :created_by
      t.boolean :completed
      t.integer :completed_by
      t.integer :priority

      t.timestamps
    end
  end
end
