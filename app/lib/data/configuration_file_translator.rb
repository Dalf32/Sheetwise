# configuration_file_translator.rb
#
# Author::  Kyle Mullins

require 'pathname'
require 'json'
require_relative 'configuration'
require_relative '../utilities/notification'

class ConfigurationFileTranslator
	def self.read_config(config_file)
		config_file = Pathname.new(config_file)

		unless config_file.exist?
			yield Notification.create_error("Configuration file #{config_file.realpath} not found.") if block_given?
			return
		end

		config_hash = read_and_parse_file(config_file)
		Configuration.new(config_hash)
	end

	def self.read_config_with_default(config_file, default_config)
		config_file = Pathname.new(config_file)

		unless config_file.exist?
			yield Notification.create_error("Configuration file #{config_file.realpath} not found, default configuration will be used instead.") if block_given?
			return Configuration.new(default_config)
		end

		config_hash = read_and_parse_file(config_file)
		Configuration.new(config_hash, default_config)
	end

	def self.write_config(configuration, config_file)
		config_file = Pathname.new(config_file)

		unless config_file.writable?
			yield Notification.create_error("Cannot access file #{config_file.realpath}, Configuration not saved.") if block_given?
			return
		end

		generate_and_write_file(configuration.to_hash, config_file)
	end

	private

	def self.read_and_parse_file(config_file)
		config_text = config_file.read
		JSON.parse(config_text, { symbolize_names: true })
	end

	def self.generate_and_write_file(config_hash, config_file)
		config_text = JSON.pretty_generate(config_hash)
		config_file.open('w+').write(config_text)
	end
end
