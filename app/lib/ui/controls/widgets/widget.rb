# widget.rb
#
# Author::  Kyle Mullins

module Widget
	GRID_ROW_KEY = :grid_row
	GRID_COL_KEY = :grid_col

	def initialize
		@is_dirty = false
	end

	def dirty?
		@is_dirty
	end
end
