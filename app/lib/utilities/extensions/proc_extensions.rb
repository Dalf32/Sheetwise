# proc_extensions.rb
#
# Author::  Kyle Mullins

module Chainable
	def chain(&other_proc)
		ChainedProc.new(self, &other_proc)
	end

	alias_method :cascade, :chain
	alias_method :pipe, :chain
end

class ChainedProc < Proc
	include Chainable

	def initialize(proc1, &proc2)
		@first_proc = proc1
		@second_proc = proc2
	end

	def call(*args)
		@second_proc.call(*@first_proc.call(*args))
	end
end

class Proc
	include Chainable
end
