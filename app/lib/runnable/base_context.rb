# base_context.rb
#
# Author::	Kyle Mullins

class BaseContext < BasicObject
  def log(message)
    ::Kernel::puts(message)
  end

  def is_empty?(*values)

  end

  def is_num?(*values)

  end

  def is_string?(*values)

  end
end