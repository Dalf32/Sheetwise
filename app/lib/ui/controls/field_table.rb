# field_table.rb
#
# Author::  Kyle Mullins

require 'tk'
require_relative '../../data/constants'

class FieldTable
	include Constants::Fields::Table

	def initialize(options_hash)
		@columns = []
		@options = options_hash
	end

	def add_column(column_name, field)
		@columns<<{ column_name => field }
	end

	def show_control(parent, row = nil, col = nil)
		@collection_frame = Tk::Tile::Frame.new(parent)
		@next_row = 0

		@columns.size.times do |n|
			TkGrid.columnconfigure(@collection_frame, n, weight: 1)
		end

		if @options[HEADERS_KEY] == SHOW_HEADERS
			TkGrid.rowconfigure(@collection_frame, 0, weight: 1)

			@columns.size.times do |n|
				Tk::Tile::Label.new(@collection_frame) do
					text @columns.key
					grid row: 0, column: n
				end
			end

			@next_row = 1
		end

		add_row
	end

	protected

	def add_row
		@columns.size.times do |n|
			column_field = @columns.value.dup
			column_field.show_control(@collection_frame)
			column_field.widget.grid(row: @next_row, column: n)
		end

		@next_row += 1
	end
end
