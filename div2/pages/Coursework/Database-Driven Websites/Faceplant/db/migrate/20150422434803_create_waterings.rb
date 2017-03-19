class CreateWaterings < ActiveRecord::Migration
  def change
    create_table :waterings do |t|
      t.date :date
      t.references :plant, index: true
    end
    add_foreign_key :waterings, :plants
  end
end
