# local_repository.rb
#
# Author::	Kyle Mullins

require 'pathname'
require_relative 'definition_listing'
require_relative 'definition_translator'
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

  private

  MAX_CACHE_SIZE = 3
  NOT_FOUND = :def_not_found
  DEFINITION_EXT = '.sdef'
  DEFINITION_LISTING = '.deflist'

  def read_definition(definition_path)
    full_path = @definition_dir.join(definition_path.nil? ? '' : definition_path)

    if File.readable?(full_path)
      return File.readlines(full_path).join
    end

    :def_not_found
  end

  def scan_definition_dir(def_dir = @definition_dir, nest_level = 0)
    def_scan_pattern = File.join(@definition_dir.realpath, "*#{DEFINITION_EXT}")
    dir_scan_pattern = File.join(@definition_dir.realpath, '*')

    Pathname.glob(def_scan_pattern).select(&:file?).select(&:readable?).each do |file|
      #TODO: Open the file and look for a definition name
      def_name = file.basename(DEFINITION_EXT).to_s

      @definitions[def_name] = file.to_s unless @definitions.contains?(def_name)
    end

    unless nest_level >= ConfigurationService.instance.max_directory_nesting
      Pathname.glob(dir_scan_pattern).select(&:directory?).select(&:readable?).each do |dir|
        unless ['.', '..'].include?(dir.to_s)
          scan_definition_dir(dir, nest_level + 1)
        end
      end
    end
  end

  def populate_definitions
    def_listing_file = Pathname.new(File.join(@definition_dir.realpath, DEFINITION_LISTING))

    if def_listing_file.readable?
      @definitions = DefinitionTranslator.parse_definition_listing(def_listing_file.readlines.join)
    else
      scan_definition_dir
    end
  end
end
