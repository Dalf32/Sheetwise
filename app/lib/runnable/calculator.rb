# calculator.rb
#
# Author::  Kyle Mullins

require_relative 'user_code'
require_relative 'calculator_context'

class Calculator
  include UserCode

  def initialize(field_id_map, *fields)
    super
  end

  def register
    UserCodeService.instance.add_calculator(@id, self)
  end

  def with(*fields, &block)
    #generate_getters
    #register to calculate
  end

  def run(field_id)
    context = CalculatorContext.new

    $SAFE = 1
    context.instance_eval(&@code_block)
  rescue RuntimeError => e
    $stderr << e
  end
end
