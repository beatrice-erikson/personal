class RemoveGrowingSeasonFromSpecies < ActiveRecord::Migration
	def change
		reversible do |dir|
			change_table :species do |t|
				dir.up   { t.remove :growing_season }
				dir.down { t.string :growing_season }
			end
		end
	end
end