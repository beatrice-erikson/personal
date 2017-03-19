class CreateRepottings < ActiveRecord::Migration
  def change
    create_table :repottings do |t|
      t.date :date
      t.references :pot, index: true
      t.references :plant, index: true
    end
    add_foreign_key :repottings, :pots
    add_foreign_key :repottings, :plants
  end
end
