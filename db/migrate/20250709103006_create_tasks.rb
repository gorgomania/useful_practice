class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :state
      t.references :project
      t.timestamps
    end
  end
end
