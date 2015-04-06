# local_repository.rb
#
# Author::	Kyle Mullins

require 'pathname'
require_relative 'definition_translator'

class LocalRepository
  #TODO: Save definition listing after scanning

  def initialize(definition_dir)
    @definition_dir = Pathname.new(definition_dir) #assert definition_dir.directory?
    @definitions = {}
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
    #TODO: Optional user-entered name stored in definition listing
    @definition_dir
  end

  def list_definitions
    @definitions.keys
  end

  def contains?(definition_name)
    @definitions.has_key?(definition_name)
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
    if File.readable?(definition_path.nil? ? '' : definition_path)
      return File.readlines(definition_path).join
    end

    :def_not_found
  end

  def scan_definition_dir(def_dir = @definition_dir)
    #TODO: Support max nesting
    def_scan_pattern = File.join(@definition_dir.realpath, "*#{DEFINITION_EXT}")
    dir_scan_pattern = File.join(@definition_dir.realpath, '*')

    Pathname.glob(def_scan_pattern).select(&:file?).select(&:readable?).each do |file|
      #TODO: Open the file and look for a definition name
      def_name = file.basename(DEFINITION_EXT).to_s

      unless @definitions.include?(def_name)
        @definitions[def_name] = file.to_s
      end
    end

    Pathname.glob(dir_scan_pattern).select(&:directory?).select(&:readable?).each do |dir|
      unless ['.', '..'].include?(dir.to_s)
        scan_definition_dir(dir)
      end
    end
  end

  def populate_definitions
    def_listing_file = Pathname.new(File.join(@definition_dir.realpath, DEFINITION_LISTING))

    if def_listing_file.readable?
      def_listing = DefinitionTranslator.parse_definition_listing(def_listing_file.readlines.join)

      def_listing.each do |def_name, def_path|
        @definitions[def_name] = File.join(@definition_dir, def_path)
      end
    else
      scan_definition_dir
    end
  end
end
