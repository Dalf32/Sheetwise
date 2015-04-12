# definition_translator.rb
#
# Author::  Kyle Mullins

require 'json'
require_relative 'definition_listing'

class DefinitionTranslator
	def self.parse_definition(definition_text)
		JSON.parse(definition_text, { symbolize_names: true })
  end

  def self.parse_definition_listing(def_listing_json)
    def_listing_hash = JSON.parse(def_listing_json)

    def_listing = DefinitionListing.new(def_listing_hash['definitions'])
    def_listing.name = def_listing_hash[:name] if def_listing_hash.include?('name')

    def_listing
  end

  def self.serialize_definition_listing(definition_listing)
    JSON.pretty_generate(definition_listing.to_h)
  end
end
