# user_code_service.rb
#
# Author::  Kyle Mullins

require 'singleton'
require_relative 'field_service'
require_relative 'sheet_service'

class UserCodeService
	def validate_all_fields

	end

	def validate_field(field_name)
		if FieldService.instance.has_validator?(field_name)
			validator = FieldService.instance.get_validator(field_name)
			field = FieldService.instance.get_field(field_name)

			result = validator.run

			if result
				field.mark_validated(true)
				calculate_for_field(field_name)
			else
				field.mark_validated(false)
			end
		end
	end

	def calculate_for_field(field_name)
		if SheetService.instance.has_dependent_calculators?(field_name)
			calculators = SheetService.instance.get_dependent_calculators(field_name)

			calculators.each{ |calculator| calculator.run }

			validate_all_fields
		end
	end
end
