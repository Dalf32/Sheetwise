# notification.rb
#
# Author::  Kyle Mullins

class Notification
	Error = Struct.new(:message, :cause)

	def initialize
		@errors = []
	end

	def add_error(message, cause = nil)
		@errors<<Error.new(message, cause)
	end

	def has_errors?
		!@errors.empty?
	end

	def each
		@errors.each{ |error| yield(error) }
	end

	def format_messages
		@errors.map{ |error| "#{error.message}, #{error.cause}" }.join('\n')
	end
end
