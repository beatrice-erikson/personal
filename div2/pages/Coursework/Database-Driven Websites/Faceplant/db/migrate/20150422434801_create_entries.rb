class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.date :date
      t.string :title
      t.text :text
      t.references :plant, index: true
    end
    add_foreign_key :entries, :plants
  end
end
