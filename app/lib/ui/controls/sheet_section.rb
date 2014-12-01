# sheet_section.rb
#
# Author::  Kyle Mullins

require 'tk'

class SheetSection
	def initialize(options)
		@options = options
		@controls = []
	end

	def add_control(row, col, control)
		if @controls[row].nil?
			@controls[row] = []
		end

		unless has_control_at?(row, col)
			@controls[row][col] = control
		end
	end

	def remove_control(row, col)
		if has_control_at?(row, col)
			@controls[row][col] = nil
		end
	end

	def has_control_at?(row, col)
		if @controls[row].nil?
			false
		else
			@controls[row][col].nil?
		end
	end

	def show_control(parent, row = nil, col = nil)
		@section_frame = Tk::Tile::Frame(parent) do
			grid row: row, column: col
		end

		@controls.size.times do |r|
			TkGrid.rowconfigure(@section_frame, r, weight: 1)

			@controls[r].size.times do |c|
				TkGrid.columnconfigure(@section_frame, c, weight: 1)

				@controls[c].show_control(@section_frame, r, c) unless @controls[c].nil?
			end unless row.nil?
		end
	end
end
