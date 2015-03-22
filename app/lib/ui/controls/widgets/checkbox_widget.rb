# checkbox_widget.rb
#
# Author::  Kyle Mullins

require 'tk'
require_relative 'widget'

class CheckboxWidget
	include Widget

	TEXT_KEY = :text
	CHECKED = 'checked'
	UNCHECKED = 'unchecked'

	def initialize(parent, text, options_hash)
		super()

		@widget = Tk::Tile::CheckButton.new(parent) do
			text text
			onvalue CHECKED
			offvalue UNCHECKED
			variable TkVariable.new
			grid row: options_hash[GRID_ROW_KEY], column: options_hash[GRID_COL_KEY]
    end

    @default_value = UNCHECKED
	end

	def value
		@widget.variable.value
	end

	def value=(new_value)
		if [CHECKED, UNCHECKED].include?(new_value)
			@widget.variable.value = new_value
			@is_dirty = true
		end
	end
end
