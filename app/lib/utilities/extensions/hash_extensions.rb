# hash_extensions.rb
#
# Author::  Kyle Mullins

require_relative 'proc_extensions'

module HashExtensions
	def transform_keys(&block)
		inject({}){ |result, (key, value)|
			new_key = block.call(key)

			new_value = case value
				            when Hash then value.transform_keys(block)
				            else value
			            end

			result[new_key] = new_value
			result
		}
	end
end

class Hash
	include HashExtensions
end

module Transforms
	Symbolize = -> key {
		case key
			when String then key.to_sym
			else key
		end
	}

	Snakeify = -> key {
		case key
			when String then key.downcase.gsub(' ', '_')
			when Symbol then key.to_s.downcase.gsub(' ', '_')
			else key
		end
	}

	CamelSpace = -> key {
		case key
			when String then key.gsub(/([a-z\d])([A-Z])/, '\1 \2')
			else key
		end
	}

	Normalize = CamelSpace.chain(&Snakeify).chain(&Symbolize)
end
