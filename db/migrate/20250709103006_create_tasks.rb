class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.string :state
      t.references :project
      t.index [ :name, :project_id ], unique: true
      t.timestamps
    end
  end
end
