# labeled_field.rb
#
# Author::  Kyle Mullins

require 'tk'
require_relative 'field'
require_relative '../../data/constants'

class LabeledField < Field
	def initialize(field_type, label_text, initial_value, options_hash)
		super(field_type, initial_value, options_hash)

		@label_text = label_text
	end

	def show_control(parent, row = nil, col = nil)
		container = Tk::Tile::Frame.new(parent) do
			grid row: row, column: col
		end

		TkGrid.rowconfigure(container, 0, weight: 1)
		TkGrid.columnconfigure(container, 0, weight: 1)
		TkGrid.columnconfigure(container, 1, weight: 1)

		label_field = Field.new(Constants::Fields::LABEL, @label_text.to_s, {})
		label_field.show_control(container, 0, 0)

		super(container, 0, 1)
	end

	def dup

	end
end
