# listbox_widget.rb
#
# Author::  Kyle Mullins

require 'tk'
require_relative 'widget'
require_relative '../../../data/definition_constants'

class ListboxWidget
	include Widget

	def initialize(parent, choices, options_hash)
		super()

		@widget = Tk::Tile::Combobox.new(parent) do
			state :readonly
			values choices
			grid row: options_hash[Constants::GRID_ROW], column: options_hash[Constants::GRID_COL]
    end

    @default_value = choices.first
	end

	def value
		@widget.value
	end

	def value=(new_value)
		if @widget.values.include?(new_value)
			@widget.set(new_value)
			@is_dirty = true
		end
	end
end
