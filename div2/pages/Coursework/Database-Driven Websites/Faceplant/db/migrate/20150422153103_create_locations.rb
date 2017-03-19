class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.text :description
      t.boolean :current
      t.references :user, index: true
    end
    add_foreign_key :locations, :users
  end
end
