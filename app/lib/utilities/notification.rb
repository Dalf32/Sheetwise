# notification.rb
#
# Author::  Kyle Mullins

class Notification
  def self.create_error(message, cause = nil)
    Struct.new(:message, :cause).new(message, cause)
  end

  def self.aggregator(notification)
    ->(error){ notification<<error }
  end

	def initialize
		@errors = []
	end

	def add_error(message, cause = nil)
		self<<create_error(message, cause)
  end

  def <<(error)
    @errors<<error
    self
  end

	def has_errors?
		!@errors.empty?
	end

  def clear_errors
    @errors.clear
  end

	def each
		@errors.each do |error| yield(error) end
	end

	def format_messages
		@errors.map{ |error| "#{error.message}"<<(error.cause.nil? ? '' : " Cause: #{error.cause}") }.join("\n")
	end
end
