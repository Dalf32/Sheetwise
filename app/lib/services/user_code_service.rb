# user_code_service.rb
#
# Author::  Kyle Mullins

require 'singleton'
require 'securerandom'
require_relative 'field_service'
require_relative 'sheet_service'
require_relative '../data/constants'
require_relative '../runnable/user_code_context'
require_relative '../data/parsing/script_parser'

class UserCodeService
	include Singleton

	def create_user_code(user_code_block, sheet_id)
    field_ids = FieldService.instance.get_field_map_for_sheet(sheet_id)
    parser = ScriptParser.new(user_code_block)
    parser.parse

    notif_block = block_given? ? Proc.new : ->{}

    if parser.failed?
      notif_block.call Notification.create_error(parser.pretty_print_failure)
    end

    #UserCodeContext.new(field_ids).evaluate(user_code_block)

    field_ids.values.each{ |field_id| validate_field(field_id) }
	end

	def validate_field(field_id)
    validation_successful = true

    get_validators(field_id).each do |validator|
      validation_successful &= Thread.new do
  			validator.run(field_id)
      end.join
    end

    #TODO: mark field 'validated' or 'validation failed'
  end

	def calculate_for_field(field_id)
		get_dependent_calculators(field_id) do |calculator|
			calculator.run
		end
	end

	def add_calculator(id, calculator)
    @calculators[id] = calculator unless @calculators.include?(id)
	end

	def get_dependent_calculators(field_id)
    get_registrations_in_hash(field_id, @calculators)
	end

	def has_dependent_calculators?(field_id)
		!get_dependent_calculators(field_id).empty?
	end

	def add_validator(id, validator)
    @validators[id] = validator unless @validators.include?(id)
  end

  def get_validators(field_id)
    get_registrations_in_hash(field_id, @validators)
  end

  def has_validators?(field_id)
    !get_validators(field_id).empty?
  end

  def register_for_field(id, field_id)
    (@registrations[field_id]<<id).uniq!
  end

	def generate_code_id
		SecureRandom.uuid
	end

	private

	def initialize
		@calculators = {}
		@validators = {}
    @registrations = Hash.new do |hash, key| hash[key] = [] end
  end

  def get_registrations_in_hash(field_id, hash)
    @registrations[field_id].map do |id|
      hash[id]
    end.compact
  end
end
