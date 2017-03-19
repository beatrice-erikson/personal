class CreateGenus < ActiveRecord::Migration
  def change
    create_table :genus do |t|
      t.string :name
    end
  end
end
