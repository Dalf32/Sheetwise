# user_code_context.rb
#
# Author::  Kyle Mullins

require_relative 'validator'
require_relative 'calculator'

class UserCodeContext < BasicObject
  def initialize(field_id_map)
    @field_id_map = field_id_map
  end

	def evaluate(code)
		::Thread.new do
			code.taint
			instance_eval("$SAFE = 1\n" + code)
		end.join
	end

	def validate(*fields)
    ::Kernel::block_given? ? ::Validator.new(@field_id_map, *fields, &::Proc.new)
        : ::Validator.new(@field_id_map, *fields)
	end

	def calculate(*fields)
    ::Kernel::block_given? ? ::Calculator.new(@field_id_map, *fields, &::Proc.new)
        : ::Calculator.new(@field_id_map, *fields)
  end
end

__END__

require_relative '../services/user_code_service'

context = UserCodeContext.new({:field1 => 1, :field2 => 2, :field3 => 3})

context.evaluate('
validate :field1, :field2 do
  log(value)
end.run(1)')

context.evaluate('
calculate(:field3).with(:field1, :field2) do

end')

3.times do |id|
  puts UserCodeService.instance.get_validators(id)
  puts UserCodeService.instance.get_dependent_calculators(id)
  puts
end