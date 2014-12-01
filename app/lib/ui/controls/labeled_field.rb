# labeled_field.rb
#
# Author::  Kyle Mullins

require 'tk'
require_relative 'field'

class LabeledField < Field
	def initialize(field_type, label_text, initial_value, options_hash)
		super(field_type, initial_value, options_hash)

		@label_text = label_text
	end

	def show_control(parent, row = nil, col = nil)
		container = Tk::Tile::Frame.new(parent)

		TkGrid.rowconfigure(container, 0, weight: 1)
		TkGrid.columnconfigure(container, 0, weight: 1)
		TkGrid.columnconfigure(container, 1, weight: 1)

		@label = Tk::Tile::Label.new(parent) do
			text @label_text.to_s
			grid row: 0, column: 0
		end

		super(container)
		@widget.grid(row: 0, column: 1)
	end

	def dup

	end
end
