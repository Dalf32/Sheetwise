# sheet_service.rb
#
# Author::  Kyle Mullins

require 'singleton'

class SheetService
	include Singleton

	attr_reader :active_sheet

	def add_sheet(sheet_name, sheet)
		if @sheets.has_key?(sheet_name)
			fail "Sheet with name: #{sheet_name} already exists; all sheets must have a unique name."
		end

		@sheets[sheet_name] = sheet
		@calculators[sheet_name] = []

		if @active_sheet.nil?
			self.active_sheet = sheet_name
		end
	end

	def get_sheet(sheet_name)
		@sheets[sheet_name]
	end

	def active_sheet=(sheet_name)
		if @sheets.has_key?(sheet_name)
			@active_sheet = sheet_name
		end
	end

	def add_calculator(calculator)
		@calculators[@active_sheet]<<calculator
	end

	def get_calculators
		@calculators[@active_sheet]
	end

	private

	def initialize
		@sheets = {}
		@active_sheet = nil
		@calculators = {}
	end
end
