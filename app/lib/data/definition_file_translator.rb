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

require_relative 'local_source'
require_relative '../services/sheet_service'

translator = DefinitionFileTranslator.new
translator.add_source(LocalSource.new(Dir.new('/home/kyle/documents/sheet_definitions')))

def_hash = translator.get_definition_hash('test')
puts def_hash
SheetService.instance.create_sheet(def_hash)
puts SheetService.instance.active_sheet.name
