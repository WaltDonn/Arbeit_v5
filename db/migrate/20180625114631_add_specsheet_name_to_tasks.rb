class AddSpecsheetNameToTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :specsheet_name, :string
  end
end
