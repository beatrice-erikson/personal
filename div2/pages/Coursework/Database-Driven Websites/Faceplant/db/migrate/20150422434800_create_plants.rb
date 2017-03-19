class CreatePlants < ActiveRecord::Migration
  def change
    create_table :plants do |t|
      t.string :name
      t.text :description
      t.date :obtained
      t.boolean :alive
      t.references :location, index: true
      t.references :pot, index: true
	  t.references :cultivar, index: true
    end
    add_foreign_key :plants, :locations
    add_foreign_key :plants, :pots
	add_foreign_key :plants, :cultivars
  end
end
