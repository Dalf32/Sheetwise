# widget.rb
#
# Author::  Kyle Mullins

require_relative '../../../data/definition_constants'

module Widget
	GRID_ROW_KEY = DefinitionConstants::GRID_ROW
	GRID_COL_KEY = DefinitionConstants::GRID_COL

  attr_reader :default_value

	def initialize
		@is_dirty = false
	end

	def dirty?
		@is_dirty
	end
end
