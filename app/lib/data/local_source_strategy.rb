# local_source_strategy.rb
#
# Author::	Kyle Mullins

class LocalSourceStrategy
  def initialize(definition_dir)
    @definition_dir = definition_dir #assert definition_dir.directory?
    @definitions = Hash.new do |cache, def_name|
      definition_file = scan_definition_dir(def_name)
      cache[def_name] = definition_file unless definition_file == NOT_FOUND
    end
  end

  def retrieve_definition(definition_name)

  end

  private

  NOT_FOUND = :def_not_found
  DEFINITION_EXT = '.sdef'

  def scan_definition_dir(definition_name)
    @definition_dir.each do |file|
      if file.file? && file.extname.downcase.eql?(DEFINITION_EXT)
        #Open the file and look for a definition name
      end
    end
  end
end