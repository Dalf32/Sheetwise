# checkbox_widget.rb
#
# Author::  Kyle Mullins

require 'tk'
require_relative 'widget'
require_relative '../../../data/definition_constants'

class CheckboxWidget
	include Widget
	include Constants::Widgets

	def initialize(parent, text, options_hash)
		super()

		@widget = Tk::Tile::CheckButton.new(parent) do
			text text
			onvalue Checkbox::CHECKED
			offvalue Checkbox::UNCHECKED
			variable TkVariable.new
			grid row: options_hash[Constants::GRID_ROW], column: options_hash[Constants::GRID_COL]
    end

    @default_value = Checkbox::UNCHECKED
	end

	def value
		@widget.variable.value
	end

	def value=(new_value)
		if [Checkbox::CHECKED, Checkbox::UNCHECKED].include?(new_value)
			@widget.variable.value = new_value
			@is_dirty = true
		end
	end
end
