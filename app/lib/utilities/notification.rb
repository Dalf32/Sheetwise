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
		self
	end

	def has_errors?
		!@errors.empty?
	end

	def each
		@errors.each do |error| yield(error) end
	end

	def format_messages
		@errors.map{ |error| "#{error.message}"<<(error.cause.nil? ? '' : ", #{error.cause}") }.join('\n')
	end
end
