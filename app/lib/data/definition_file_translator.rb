# definition_file_translator.rb
#
# Author::  Kyle Mullins

require 'json'

class DefinitionFileTranslator
	def initialize
		@sources = []
	end

	def add_source(source)
		@sources<<source
	end

	def get_definition_hash(definition_name)
		def_text = find_definition(definition_name)
		JSON.parse(def_text, { symbolize_names: true })
	end

	private

	def find_definition(definition_name)
		@sources.each do |source|
			definition = source.retrieve_definition(definition_name)

			return definition unless definition.nil?
		end

		nil
	end
end
