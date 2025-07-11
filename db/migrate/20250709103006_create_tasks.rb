class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :status, default: "To Do"
      t.references :project
      t.timestamps
    end
  end
end
