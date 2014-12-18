# configuration_file_translator.rb
#
# Author::  Kyle Mullins

require 'json'
require_relative '../utilities/configuration'

class ConfigurationFileTranslator
	def initialize(file)
		@config_file = file
	end

	def read_config
		config_text = File.open(@config_file, 'r').readlines.join
		config_hash = JSON.parse(config_text, { symbolize_names: true })

		Configuration.new(config_hash)
	end

	def write_config(configuration)
		config_text = JSON.pretty_generate(configuration.to_hash)
		File.open(@config_file, 'w+').write(config_text)
	end
end
