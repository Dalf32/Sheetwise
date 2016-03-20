# validator.rb
#
# Author::  Kyle Mullins

require_relative 'user_code'
require_relative 'validator_context'

class Validator
  include UserCode

  def initialize(field_id_map, *fields)
    super
  end

  def register
    UserCodeService.instance.add_validator(@id, self)
  end

  def with(*fields, &block)
    @code_block = block
    @gettable_fields = fields
  end

	def run(field_id)
    puts field_id
    context = ValidatorContext.new
    generate_field_getter(context, 'value', field_id)

		$SAFE = 1
		context.instance_eval(&@code_block)
	rescue RuntimeError => e
		#Signifies validation failure: bubble result up
    $stderr << e
  end
end
