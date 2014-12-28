# configuration_file_translator.rb
#
# Author::  Kyle Mullins

require 'json'
require_relative 'configuration'
require_relative '../utilities/notification'

class ConfigurationFileTranslator
	def initialize(file)
		@config_file = file
	end

	def read_config
		unless File.exists?(@config_file)
			yield Notification.new.add_error("Configuration file #{@config_file} not found.") if block_given?
			return
		end

		config_hash = read_and_parse_file
		Configuration.new(config_hash)
	end

	def read_config_with_default(default_config)
		unless File.exists?(@config_file)
			yield Notification.new.add_error("Configuration file #{@config_file} not found, default configuration will be used instead.") if block_given?
			return Configuration.new(default_config)
		end

		config_hash = read_and_parse_file
		Configuration.new(config_hash, default_config)
	end

	def write_config(configuration)
		config_text = JSON.pretty_generate(configuration.to_hash)
		File.open(@config_file, 'w+').write(config_text)
	end

	private

	def read_and_parse_file
		config_text = File.open(@config_file, 'r').readlines.join
		config_hash = JSON.parse(config_text, { symbolize_names: true })
	end
end