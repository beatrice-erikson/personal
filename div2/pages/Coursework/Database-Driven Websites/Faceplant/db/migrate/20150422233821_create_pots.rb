class CreatePots < ActiveRecord::Migration
  def change
    create_table :pots do |t|
      t.boolean :owned
      t.integer :width
      t.integer :height
      t.string :color
      t.string :material
      t.references :user, index: true
    end
    add_foreign_key :pots, :users
  end
end
