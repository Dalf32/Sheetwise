# calculator.rb
#
# Author::  Kyle Mullins

require_relative 'user_code'
require_relative '../services/field_service'

class Calculator < UserCode
	attr_reader :field_dependencies

	def initialize(code_block, field_dependencies)
		super(code_block)

		@field_dependencies = field_dependencies
	end

	protected

	def get_run_params
		@field_dependencies.inject({}){|params, field_name|
			params[field_name] = FieldService.instance.get_field(field_name)
		}
	end
end
