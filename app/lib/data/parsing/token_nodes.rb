# token_nodes.rb
#
# Author::	Kyle Mullins

module LiteralNode
  def to_ruby
    text_value
  end
end

module WhitespaceNode
  def to_ruby
    text_value
  end
end

module IdentifierNode
  def to_ruby
    text_value
  end
end
