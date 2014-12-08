# listbox_widget.rb
#
# Author::  Kyle Mullins

require 'tk'
require_relative 'widget'

class ListboxWidget
	include Widget

	CHOICES_KEY = :choices

	def initialize(parent, choices, options_hash)
		super()

		@widget = Tk::Tile::Combobox.new(parent) do
			state :readonly
			values choices
		end
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
