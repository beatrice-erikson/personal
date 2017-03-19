class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :filepath
      t.date :taken
      t.text :description
      t.boolean :is_disp
      t.references :entry, index: true
    end
    add_foreign_key :pictures, :entries
  end
end
