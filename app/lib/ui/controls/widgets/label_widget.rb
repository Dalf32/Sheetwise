# label_widget.rb
#
# Author::  Kyle Mullins

require 'tk'
require_relative 'all_widgets'

class LabelWidget
	include Widget

	STYLE_KEY = :style
	HEADING_STYLE = :heading
	NORMAL_STYLE = :normal

	def initialize(parent, options_hash)
		@is_dirty = false
		@widget = Tk::Tile::Label.new(parent)

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
		@widget.value
	end

	def value=(new_value)
		@widget.value = new_value.to_s
		@is_dirty = true
	end

	def dirty?
		@is_dirty
	end
end
