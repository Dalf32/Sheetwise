# definition_listing.rb
#
# Author::	Kyle Mullins

class DefinitionListing
  attr_accessor :name, :exclusions

  def initialize(listing = {}, name = nil)
    @name = name
    @listing = listing
    @exclusions = []
  end

  def has_name?
    !@name.nil?
  end

  def list_definitions
    @listing.keys
  end

  def contains?(definition_name)
    @listing.include?(definition_name)
  end

  def [](definition_name)
    get_definition(definition_name)
  end

  def []=(definition_name, def_path)
    add_definition(definition_name, def_path)
  end

  def add_definition(definition_name, path)
    @listing[definition_name] = path
  end

  def add_multiple(definitions_hash)
    @listing.merge!(definitions_hash)
  end

  def get_definition(definition_name)
    @listing[definition_name]
  end

  def delete_definition(definition_name)
    @listing.delete(definition_name)
  end

  def rename_definition(old_name, new_name)
    @listing[new_name] = @listing.delete(old_name)
  end

  def to_h
    @listing.dup
  end
end