# text_widget.rb
#
# Author::  Kyle Mullins

require 'tk'
require_relative 'widget'
require_relative '../../../data/constants'

class TextWidget
	include Widget
	include Constants::Widgets

	def initialize(parent, options_hash)
		super()

		if options_hash[Text::MULTILINE_KEY]
			@widget = TkText.new(parent) do
				grid row: options_hash[Constants::GRID_ROW], column: options_hash[Constants::GRID_COL]
				width 20
				height 5
			end
			#TODO: configure multiline widgets
		else
			@widget = Tk::Tile::Entry.new(parent) do
				grid row: options_hash[Constants::GRID_ROW], column: options_hash[Constants::GRID_COL]
			end
			#TODO: configure single line widgets
    end

    @default_value = ''

		if options_hash[Text::READONLY_KEY]
			#TODO: set widgets to readonly
		end
	end

	def value
		@widget.value
	end

	def value=(new_value)
		@widget.value = new_value.to_s
		@is_dirty = true
	end
end
