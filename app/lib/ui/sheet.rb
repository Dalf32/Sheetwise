# sheet.rb
#
# Author::  Kyle Mullins

require 'tk'
require_relative 'controls/sheet_section'

class Sheet
	def initialize
		@root_sheet_section = SheetSection.new({ })
	end

	def display_sheet(parent)
		sheet_frame = Tk::Tile::Frame.new(parent)
		@root_sheet_section.show_control(parent)
	end
end
