# local_repository.rb
#
# Author::	Kyle Mullins

require 'pathname'
require_relative 'definition_listing'
require_relative 'definition_translator'
require_relative 'definition_constants'
require_relative '../services/configuration_service'

class LocalRepository
  #TODO: Save definition listing after scanning

  def initialize(definition_dir)
    @definition_dir = Pathname.new(definition_dir) #assert definition_dir.directory?
    @definitions = DefinitionListing.new
    @definition_cache = Hash.new do |cache, def_name|
      file_contents = read_definition(@definitions[def_name])

      if file_contents == NOT_FOUND
        return NOT_FOUND
      end

      cache[def_name] = file_contents unless file_contents == NOT_FOUND
    end

    populate_definitions
  end

  def display_name
    if @definitions.has_name?
      @definitions.name
    else
      @definition_dir
    end
  end

  def list_definitions
    @definitions.list_definitions
  end

  def contains?(definition_name)
    @definitions.contains?(definition_name)
  end

  def retrieve_definition(definition_name)
		@definition_cache[definition_name]
  end

  def rename_definition(old_name, new_name)
    @definitions.rename_definition(old_name, new_name) if contains?(old_name)
  end

  def add_definition(definition_name, definition_path)
    @definitions.add_definition(definition_name, definition_path) unless contains?(definition_name)
  end

  def refresh_repository
    remove_missing_definitions
    scan_definition_dir
  end

  private

  MAX_CACHE_SIZE = 3
  NOT_FOUND = :def_not_found
  DEFINITION_EXT = '.sdef'
  DEFINITION_LISTING = '.deflist'

  def full_repo_path(path)
    @definition_dir.realpath.join(path.nil? ? '' : path)
  end

  def read_definition(definition_path)
    full_path = full_repo_path(definition_path)
    return full_path.read if full_path.readable?

    :def_not_found
  end

  def populate_definitions
    def_listing_file = full_repo_path(DEFINITION_LISTING)

    if def_listing_file.readable?
      @definitions = DefinitionTranslator.parse_definition_listing(def_listing_file.read)
    else
      scan_definition_dir
    end
  end

  #TODO: Support for directory exclusion/pruning
  def scan_definition_dir(def_dir = @definition_dir, nest_level = 0)
    def_scan_pattern = def_dir.join("*#{DEFINITION_EXT}")
    dir_scan_pattern = def_dir.join('*')

    Pathname.glob(def_scan_pattern).select(&:file?).select(&:readable?).each do |file|
      definition_hash = DefinitionTranslator.parse_definition(read_definition(file))
      def_name = definition_hash[Constants::NAME]

      @definitions[def_name] = file.to_s unless def_name.nil? || @definitions.contains?(def_name)
    end

    unless nest_level >= ConfigurationService.instance.max_directory_nesting
      Pathname.glob(dir_scan_pattern).select(&:directory?).select(&:readable?).each do |dir|
        unless ['.', '..'].include?(dir.to_s)
          scan_definition_dir(dir, nest_level + 1)
        end
      end
    end
  end

  def remove_missing_definitions
    list_definitions.each do |def_name|
      unless full_repo_path(def_name).readable?
        @definitions.delete_definition(def_name)
      end
    end
  end
end
