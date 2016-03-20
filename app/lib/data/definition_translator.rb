# definition_translator.rb
#
# Author::  Kyle Mullins

require 'json'
require_relative 'definition_listing'
require_relative 'constants'

class DefinitionTranslator
  include Constants::Listing

	def self.parse_definition(definition)
    unless definition.parsed?
      def_json, def_code = definition.raw_text.split(Constants::CODE_BLOCK)
      def_structure = JSON.parse(def_json, { symbolize_names: true })

      definition.set_parsed_data(def_structure, def_code)
    end

    definition
  end

  def self.parse_definition_listing(def_listing_json)
    def_listing_hash = JSON.parse(def_listing_json)

    def_listing = DefinitionListing.new(def_listing_hash[DEFINITIONS])
    def_listing.name = def_listing_hash[NAME] if def_listing_hash.include?(NAME)
    def_listing.exclusions = def_listing_hash[EXCLUSIONS] if def_listing_hash.include?(NAME)

    def_listing
  end

  def self.serialize_definition_listing(definition_listing)
    def_listing_hash = { DEFINITIONS => definition_listing.to_h }
    def_listing_hash[NAME] = definition_listing.name if definition_listing.has_name?
    def_listing_hash[EXCLUSIONS] = definition_listing.exclusions

    JSON.pretty_generate(def_listing_hash)
  end
end
