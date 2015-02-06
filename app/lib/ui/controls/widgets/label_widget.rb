# label_widget.rb
#
# Author::  Kyle Mullins

require 'tk'
require_relative 'widget'

class LabelWidget
	include Widget

	STYLE_KEY = :style
	HEADING_STYLE = :heading
	NORMAL_STYLE = :normal

	def initialize(parent, options_hash)
		super()

		@widget = Tk::Tile::Label.new(parent) do
			grid row: options_hash[GRID_ROW_KEY], column: options_hash[GRID_COL_KEY]
		end

		case options_hash[STYLE_KEY]
			when HEADING_STYLE
				#TODO: heading styling
			when NORMAL_STYLE
				#TODO: normal styling
			else
				fail "Invalid style: #{options_hash[STYLE_KEY]}"
		end
	end

	def value
		@widget.text
	end

	def value=(new_value)
		@widget.text = new_value.to_s
	end
end
