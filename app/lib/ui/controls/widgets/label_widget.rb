# label_widget.rb
#
# Author::  Kyle Mullins

require 'tk'
require_relative 'widget'
require_relative '../../../data/definition_constants'

class LabelWidget
	include Widget
	include Constants::Widgets

	def initialize(parent, options_hash)
		super()

		@widget = Tk::Tile::Label.new(parent) do
			grid row: options_hash[Constants::GRID_ROW], column: options_hash[Constants::GRID_COL]
    end

    @default_value = ''

		case options_hash[Label::STYLE_KEY]
			when Label::HEADING_STYLE
				#TODO: heading styling
			when Label::NORMAL_STYLE
				#TODO: normal styling
			else
				fail "Invalid style: #{options_hash[Label::STYLE_KEY]}"
		end
	end

	def value
		@widget.text
	end

	def value=(new_value)
		@widget.text = new_value.to_s
	end
end
