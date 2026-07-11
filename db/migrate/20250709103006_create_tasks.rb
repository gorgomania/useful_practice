class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.string :state, null: false
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.index [ :name, :project_id ], unique: true
      t.timestamps
    end
  end
end
