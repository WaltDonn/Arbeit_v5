class AddSpecsheetToTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :specsheet, :string
  end
end
