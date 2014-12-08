# text_widget.rb
#
# Author::  Kyle Mullins

require 'tk'
require_relative 'widget'

class TextWidget
	include Widget

	MULTILINE_KEY = :is_multiline
	READONLY_KEY = :is_readonly

	def initialize(parent, options_hash)
		super()

		if options_hash[MULTILINE_KEY]
			@widget = Tk::Tile::Text.new(parent)
			#TODO: configure multiline widgets
		else
			@widget = Tk::Tile::Entry.new(parent)
			#TODO: configure single line widgets
		end

		if options_hash[READONLY_KEY]
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
