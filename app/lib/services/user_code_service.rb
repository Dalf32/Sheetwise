# user_code_service.rb
#
# Author::  Kyle Mullins

require 'singleton'
require_relative 'field_service'
require_relative 'sheet_service'
require_relative '../data/definition_constants'

class UserCodeService
	include Singleton

	def create_user_code(user_code_def_hash)
		validators = create_validators(user_code_def_hash)
		calculators = create_calculators(user_code_def_hash)

		validators.each do |validator| add_validator(validator) end
		calculators.each do |calculator| add_calculator(calculator) end
	end

	def validate_field(field_name)
		if has_validator?(field_name)
			validator = FieldService.instance.get_validator(field_name)
			field = FieldService.instance.get_field(field_name)

			validation_successful = validator.run
			field.mark_validated(validation_successful)
		end
	end

	def calculate_for_field(field_name)
		if has_dependent_calculators?(field_name)
			calculators = get_dependent_calculators(field_name)

			calculators.each do |calculator| calculator.run end
			#TODO: field.mark_ok()
		end
	end

	def add_calculator(calculator)
		@calculators[SheetService.instance.active_sheet]<<calculator
	end

	def calculators
		@calculators[SheetService.instance.active_sheet]
	end

	def get_dependent_calculators(field_name)
		calculators.collect do |calculator|
			calculator.field_dependencies.include?(field_name)
		end
	end

	def has_dependent_calculators?(field_name)
		!get_dependent_calculators(field_name).empty?
	end

	def add_validator(validator)
		#Store as Field@Sheet => { calculators => [calcs], validator => valid }

		@validators[SheetService.instance.active_sheet]<<validator
	end

	private

	def initialize
		@calculators = Hash.new do |hash, key| hash[key] = [] end
		@validators = Hash.new do |hash, key| hash[key] = [] end
	end

	def create_validators(user_code_def_hash)
		user_code_def_hash[Constants::VALIDATOR_LIST].each do |validator_hash|

		end
	end

	def create_calculators(user_code_def_hash)
		calculators = []

		user_code_def_hash[Constants::CALCULATOR_LIST].each do |calculator_hash|

		end

		calculators
	end
end
