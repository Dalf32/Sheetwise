# definition.rb
#
# Author::	Kyle Mullins

class Definition
  attr_reader :raw_text, :structure, :code_block

  def initialize(raw_text)
    @raw_text = raw_text
    @parsed = false
  end

  def parsed?
    @parsed
  end

  def set_parsed_data(structure_hash, code_block)
    @structure = structure_hash
    @code_block = code_block
    @parsed = true
  end
end