# field_service.rb
#
# Author::  Kyle Mullins

require 'singleton'
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

    add_field(field_name, field) unless field_type.nil? || field_name.nil?
	end

	def add_field(field_name, field)
		qualified_name = qualify_field_name(field_name)

		if @fields.has_key?(qualified_name)
			fail "Field with name: #{field_name} already exists; all fields must have a unique name."
		end

		@fields[qualified_name] = field
	end

	def remove_field(field_name)
		@fields.delete(qualify_field_name(field_name))
	end

	def remove_fields_for_sheet(sheet_id)
		@fields.delete_if do |name, field| name.end_with?(qualify_field_name('', sheet_id)) end
	end

	def get_field(field_name)
		@fields[qualify_field_name(field_name)]
	end

	def get_all_fields
		@fields.collect{ |name, field| name.end_with?(qualify_field_name('')) }
	end

	def get_unvalidated_fields
		get_all_fields.collect{ |name, field| !field.validated? }
	end

	def add_validator(validator)
		# if has_validator?(validator.target_field)
		# 	fail "Field with name: #{validator.target_field} already has validator; a field may have at most one validator."
		# end
		#
		# @validators[validator.target_field] = validator
	end

	def get_validator(field_name)
		@validators[qualify_field_name(field_name)]
	end

	def has_validator?(field_name)
		@validators.has_key?(qualify_field_name(field_name))
	end

	private

	NAME_SEPARATOR = '@'

	def initialize
		@fields = {}
		@validators = {}
	end

	def qualify_field_name(field_name, sheet_id = SheetService.instance.active_sheet_id)
		field_name + NAME_SEPARATOR + sheet_id
	end
end
