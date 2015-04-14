# widget.rb
#
# Author::  Kyle Mullins

require_relative '../../../data/definition_constants'

module Widget
  attr_reader :default_value

	def initialize
		@is_dirty = false
	end

	def dirty?
		@is_dirty
	end
end
