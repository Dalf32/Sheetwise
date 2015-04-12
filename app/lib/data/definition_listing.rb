# definition_listing.rb
#
# Author::	Kyle Mullins

class DefinitionListing
  attr_accessor :name

  def initialize(listing = {}, name = nil)
    @name = name
    @listing = listing
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

  def to_h
    hash = { definitions: @listing }
    hash[:name] = @name if has_name?

    hash
  end
end