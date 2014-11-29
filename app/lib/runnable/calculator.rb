# calculator.rb
#
# Author::  Kyle Mullins

require_relative 'user_code'

class Calculator < UserCode
	attr_reader :field_dependencies

	def initialize(code_block, field_dependencies)
		super(code_block)

		@field_dependencies = field_dependencies
	end
end
