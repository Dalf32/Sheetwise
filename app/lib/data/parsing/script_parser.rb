# script_parser.rb
#
# Author::	Kyle Mullins

require 'treetop'
require_relative 'Tokens'
require_relative 'Arithmetic'
require_relative 'BooleanLogic'
require_relative 'SheetScript'
require_relative 'token_nodes'
require_relative 'arithmetic_nodes'
require_relative 'boolean_logic_nodes'

class ScriptParser
  def initialize(input_text, parser = SheetScriptParser.new)
    @input_text = input_text
    @parser = parser
  end

  def parse
    @ast = @parser.parse(@input_text)
  end

  def succeeded?
    !failed?
  end

  def failed?
    @ast.nil?
  end

  def pretty_print_failure
    lines = @input_text.lines.to_a[(@parser.failure_line - 2)..@parser.failure_line]

    failure = @parser.failure_reason.split(/\(byte \d+\) after/).first
    failure += "\n"
    failure += lines.map.with_index{ |line, n| '%2d  |%s' % [(@parser.failure_line - 1 + n), line] }.join
    failure += "\n" if lines.count == 1
    failure + (' ' * (@parser.failure_column + 4)) + '^'
  end
end
