class CreateCultivars < ActiveRecord::Migration
  def change
    create_table :cultivars do |t|
      t.string :name
      t.references :species, index: true
    end
    add_foreign_key :cultivars, :species
  end
end
