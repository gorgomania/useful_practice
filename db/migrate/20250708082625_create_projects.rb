class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :goal
      t.string :description
      t.references :user
      t.index [ :name, :user_id ], unique: true
      t.timestamps
    end
  end
end
