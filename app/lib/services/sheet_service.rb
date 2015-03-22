# sheet_service.rb
#
# Author::  Kyle Mullins

require 'singleton'
require 'securerandom'
require_relative 'field_service'
require_relative 'user_code_service'
require_relative '../data/definition_constants'
require_relative '../ui/sheet'
require_relative '../ui/controls/sheet_section'
require_relative '../utilities/notification'

class SheetService
	include Singleton

	attr_reader :active_sheet, :active_sheet_id

	def create_sheet(sheet_def_hash)
		sheet_name = sheet_def_hash[DefinitionConstants::NAME]

    notif_block = block_given? ? Proc.new : ->{}

    if sheet_name.nil?
      notif_block.call Notification.create_error("Sheet not created, 'Name' is required.")
      return nil
    end

    sheet_id = SecureRandom.uuid
    sheet = Sheet.new(sheet_id, sheet_name)

    add_sheet(sheet)
    prev_active_sheet = @active_sheet
    self.active_sheet = sheet

    root_section = create_controls(sheet_def_hash, 'root', &notif_block)

    if root_section.nil?
      notif_block.call Notification.create_error("Failed to create Sheet #{sheet_name}.")
      remove_sheet(sheet.id)
      self.active_sheet = prev_active_sheet

      return nil
    end

		sheet.set_controls(root_section)
		sheet
	end

	def add_sheet(sheet)
		@sheets[sheet.id] = sheet

		if @active_sheet.nil?
			self.active_sheet_id = sheet.id
		end
	end

	def get_sheet(sheet_id)
		@sheets[sheet_id]
  end

  def remove_sheet(sheet_id)
    FieldService.instance.remove_fields_for_sheet(sheet_id)
    @sheets.delete(sheet_id)
    #TODO: Handle active_sheet?
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

	def create_controls(sheet_def_hash, section_name, &notif_block)
    if section_name.nil?
      yield Notification.create_error("Section not created, 'Name' is required.")
      return nil
    end

		root_section = SheetSection.new({})

		sheet_def_hash[DefinitionConstants::CONTROL_LIST].each do |control_hash|
      control_type = control_hash[DefinitionConstants::FIELD_TYPE]

      if control_type == DefinitionConstants::SECTION
        control = create_controls(control_hash, control_hash[DefinitionConstants::NAME], &notif_block)
      else
        control = FieldService.instance.create_field(control_hash, &notif_block)
      end

      row = control_hash[DefinitionConstants::GRID_ROW]
      col = control_hash[DefinitionConstants::GRID_COL]

      if row.nil? || col.nil?
        yield Notification.create_error("Control not added to Section: #{section_name}, 'Row' and 'Col' are required.")
        next
      end

      root_section.add_control(row, col, control) unless control.nil?
		end

		root_section
	end
end
