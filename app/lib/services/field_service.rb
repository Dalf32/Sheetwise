# field_service.rb
#
# Author::  Kyle Mullins

require 'singleton'
require 'securerandom'
require_relative 'sheet_service'
require_relative '../utilities/notification'

class FieldService
	include Singleton

	def create_field(field_def_hash)
    field_type = field_def_hash[DefinitionConstants::FIELD_TYPE]
    field_name = field_def_hash[DefinitionConstants::NAME]

    if field_type.nil?
      yield Notification.create_error("Field not created, 'Type' is required.") if block_given?
    end

    field = Field.new(field_type, field_def_hash[DefinitionConstants::FIELD_VALUE], field_def_hash)

    if field_name.nil?
      yield Notification.create_error("Field not added to Sheet, 'Name' is required.") if block_given?
    end

    field_id = SecureRandom.uuid

    add_field(field_id, field) unless field_type.nil? || field_name.nil?
    [field_id, field]
	end

	def add_field(field_id, field)
		if @fields.has_key?(field_id)
			fail "Field with ID: #{field_id} already exists; all fields must have a unique ID."
		end

		@fields[field_id] = field
	end

	def remove_field(field_id)
		@fields.delete(field_id)
	end

	def remove_fields_for_sheet(sheet_id)
    fields_for_sheet = get_fields_for_sheet(sheet_id)
		@fields.delete_if do |field_id, _field| fields_for_sheet.include?(field_id) end
	end

	def get_field(field_id)
		@fields[field_id]
	end

	def get_fields_for_sheet(sheet_id)
    field_ids = SheetService.instance.get_sheet_controls(sheet_id)
    field_ids.inject([]){ |fields_for_sheet, field_id| fields_for_sheet<<@fields[field_id] }.compact
	end

	def get_unvalidated_fields
		get_fields_for_sheet.collect{ |field| !field.validated? }
	end

	def add_validator(validator)
		# if has_validator?(validator.target_field)
		# 	fail "Field with name: #{validator.target_field} already has validator; a field may have at most one validator."
		# end
		#
		# @validators[validator.target_field] = validator
	end

	def get_validator(field_id)
		@validators[field_id]
	end

	def has_validator?(field_id)
		@validators.has_key?(field_id)
	end

	private

	def initialize
		@fields = {}
		@validators = {}
	end
end
