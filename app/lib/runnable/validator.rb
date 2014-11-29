# validator.rb
#
# Author::  Kyle Mullins

require_relative 'user_code'

class Validator < UserCode
	attr_reader :target_field

	def validator(user_code, target_field)
		super(user_code)

		@target_field = target_field
	end
end
