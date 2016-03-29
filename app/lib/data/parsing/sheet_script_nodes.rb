# sheet_script_nodes.rb
#
# Author::	Kyle Mullins

class Treetop::Runtime::SyntaxNode
  def to_ruby
    elements.map(&:to_ruby).join unless elements.nil?
  end
end

module ScriptNode
  def to_ruby
    super
  end
end

module ValidatorNode
  def to_ruby
    'validate' + super + 'done'
  end
end

module CalculatorNode
  def to_ruby
    'calculate' + super + 'done'
  end
end

module CommentNode
  def to_ruby
    ''
  end
end

module DefinitionHeaderNode
  def to_ruby
    ruby_text = "(#{validate_params.text_value})"
    ruby_text += validate_with.with_stmnt.to_ruby unless validate_with.to_ruby.nil?
    ruby_text + ' do'
  end
end

module WithNode
  def to_ruby
    ".with(#{with_params.to_ruby})"
  end
end
