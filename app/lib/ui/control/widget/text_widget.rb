# text_widget.rb
#
# Author::  Kyle Mullins

require 'tk'

class TextWidget
	MULTILINE_KEY = :is_multiline
	READONLY_KEY = :is_readonly

	def initialize(parent, options_hash)
		@is_dirty = false

		if options_hash[MULTILINE_KEY]
			@widget = Tk::Tile::Text.new(parent)
			#TODO: configure multiline widget
		else
			@widget = Tk::Tile::Entry.new(parent)
			#TODO: configure single line widget
		end

		if options_hash[READONLY_KEY]
			#TODO: set widget to readonly
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
