# field_service.rb
#
# Author::  Kyle Mullins

require 'singleton'
require_relative 'sheet_service'

class FieldService
	include Singleton

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

	def remove_fields_for_sheet(sheet_name)
		@fields.delete_if{ |key, value| key.end_with?(qualify_field_name('', sheet_name)) }
	end

	def get_field(field_name)
		@fields[qualify_field_name(field_name)]
	end

	def add_validator(validator)
		if has_validator?(validator.target_field)
			fail "Field with name: #{validator.target_field} already has validator; a field may have at most one validator."
		end

		@validators[validator.target_field] = validator
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

	def qualify_field_name(field_name, sheet_name = SheetService.instance.active_sheet)
		field_name + NAME_SEPARATOR + sheet_name
	end
end
