# sheet.rb
#
# Author::  Kyle Mullins

require 'tk'
require_relative 'controls/sheet_section'

class Sheet
	attr_reader :id, :name, :title

	def initialize(id, sheet_name)
		@id = id
		@name = sheet_name
		@title = sheet_name
		@root_sheet_section = nil
	end

	def set_controls(root_section)
		@root_sheet_section = root_section
	end

	def display_sheet(parent)
		sheet_frame = Tk::Tile::Frame.new(parent) do
			pack side: 'left', padx: 0, pady: 0, fill: 'both', expand: 1
			padding '3 3 12 12'
		end

		@root_sheet_section.show_control(sheet_frame)
	end
end
