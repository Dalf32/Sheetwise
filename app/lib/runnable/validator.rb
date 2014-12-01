# validator.rb
#
# Author::  Kyle Mullins

require_relative 'user_code'
require_relative '../services/field_service'

class Validator < UserCode
	attr_reader :target_field

	def validator(user_code, target_field)
		super(user_code)

		@target_field = target_field
	end

	protected

	def get_run_params
		{ @target_field => FieldService.instance.get_field(@target_field) }
	end
end
