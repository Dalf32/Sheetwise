# sheet_service.rb
#
# Author::  Kyle Mullins

require 'singleton'
require_relative 'field_service'
require_relative 'user_code_service'
require_relative '../ui/sheet'
require_relative '../ui/controls/sheet_section'

class SheetService
	include Singleton

	attr_reader :active_sheet, :active_sheet_id

	def create_sheet(sheet_def_hash)
		#TODO: Extract hash keys to constants file
		sheet_name = sheet_def_hash['name']
		sheet = Sheet.new(SecureRandom.uuid, sheet_name)

		sheet.set_controls(create_controls(sheet_def_hash))

		add_sheet(sheet.id, sheet)
		self.active_sheet = sheet
	end

	def add_sheet(sheet_id, sheet)
		@sheets[sheet_id] = sheet

		if @active_sheet.nil?
			self.active_sheet = sheet_id
		end
	end

	def get_sheet(sheet_id)
		@sheets[sheet_id]
	end

	def active_sheet=(sheet)
		if @sheets.has_key?(sheet.id)
			@active_sheet = sheet
			@active_sheet_id = sheet.id
		end
	end

	def active_sheet_id=(sheet_id)
		if @sheets.has_key?(sheet_id)
			@active_sheet_id = sheet_id
			@active_sheet = @sheets[sheet_id]
		end
	end

	private

	def initialize
		@sheets = {}
		@active_sheet = nil
	end

	def create_controls(sheet_def_hash)
		root_section = SheetSection.new({})

		sheet_def_hash['controls'].each do |control_hash|

		end

		root_section
	end
end
