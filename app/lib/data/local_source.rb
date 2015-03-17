# local_source.rb
#
# Author::	Kyle Mullins

require 'pathname'

class LocalSource
  def initialize(definition_dir)
    @definition_dir = Pathname.new(definition_dir) #assert definition_dir.directory?
    @definitions = Hash.new do |cache, def_name|
      file_contents = scan_definition_dir(def_name)
      cache[def_name] = file_contents unless file_contents == NOT_FOUND
    end
  end

  def retrieve_definition(definition_name)
		@definitions[definition_name]
  end

  private

  NOT_FOUND = :def_not_found
  DEFINITION_EXT = '.sdef'

  def scan_definition_dir(definition_name)
    @definition_dir.each_child do |file|
	    if file.file? && file.extname.downcase.eql?(DEFINITION_EXT)
        #TODO: Open the file and look for a definition name
		    if file.basename(DEFINITION_EXT).to_s.downcase.eql?(definition_name.downcase)
					return file.readlines.join
		    end
      end
    end

		NOT_FOUND
  end
end
