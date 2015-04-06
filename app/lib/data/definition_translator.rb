# definition_translator.rb
#
# Author::  Kyle Mullins

require 'json'

class DefinitionTranslator
	def self.parse_definition(definition_text)
		JSON.parse(definition_text, { symbolize_names: true })
  end

  def self.parse_definition_listing(definition_listing)
    JSON.parse(definition_listing)
  end
end
