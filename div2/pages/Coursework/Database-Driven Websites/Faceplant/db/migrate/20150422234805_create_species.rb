class CreateSpecies < ActiveRecord::Migration
  def change
    create_table :species do |t|
      t.string :name
	  t.string :growing_season
      t.references :genus, index: true
    end
    add_foreign_key :species, :genus
  end
end
