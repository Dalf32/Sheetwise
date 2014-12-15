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
		sheet_frame = Tk::Tile::Frame.new(parent)
		@root_sheet_section.show_control(parent)
	end
end
