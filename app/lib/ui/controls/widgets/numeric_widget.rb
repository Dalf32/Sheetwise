# numeric_widget.rb
#
# Author::  Kyle Mullins

require_relative 'text_widget'

class NumericWidget < TextWidget
	def value
		super.to_i
	end

	def value=(new_value)
		super(new_value.to_i)
	end
end
