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
  include Constants

	def create_sheet(sheet_def_hash)
		sheet_name = sheet_def_hash[NAME]

    notif_block = block_given? ? Proc.new : ->{}

    if sheet_name.nil?
      notif_block.call Notification.create_error("Sheet not created, 'Name' is required.")
      return nil
    end

    sheet_id = SecureRandom.uuid
    sheet = Sheet.new(sheet_id, sheet_name)

    add_sheet(sheet)

    root_section = create_controls(sheet_id, sheet_def_hash, 'root', &notif_block)

    if root_section.nil?
      notif_block.call Notification.create_error("Failed to create Sheet #{sheet_name}.")
      remove_sheet(sheet.id)

      return nil
    end

		sheet.set_controls(root_section)
		sheet
	end

	def add_sheet(sheet)
		@sheets[sheet.id] = sheet
	end

	def get_sheet(sheet_id)
		@sheets[sheet_id]
  end

  def get_sheet_controls(sheet_id)
    @sheet_controls[sheet_id]
  end

  def remove_sheet(sheet_id)
    FieldService.instance.remove_fields_for_sheet(sheet_id)
    @sheets.delete(sheet_id)
  end

	private

	def initialize
		@sheets = {}
    @sheet_controls = Hash.new{|hash, key| hash[key] = []}
	end

	def create_controls(sheet_id, sheet_def_hash, section_name, &notif_block)
    if section_name.nil?
      yield Notification.create_error("Section not created, 'Name' is required.")
      return nil
    end

		root_section = SheetSection.new({})

		sheet_def_hash[CONTROL_LIST].each do |control_hash|
      control_type = control_hash[FIELD_TYPE]

      if control_type == SECTION
        control = create_controls(sheet_id, control_hash, control_hash[NAME], &notif_block)
      else
        control_id, control = *FieldService.instance.create_field(control_hash, &notif_block)
      end

      row = control_hash[GRID_ROW]
      col = control_hash[GRID_COL]

      if row.nil? || col.nil?
        yield Notification.create_error("Control not added to Section: #{section_name}, 'Row' and 'Col' are required.")
        next
      end

      root_section.add_control(row, col, control) unless control.nil?
      @sheet_controls[sheet_id]<<control_id unless control_id.nil?
		end

		root_section
	end
end
