# user_code.rb
#
# Author::	Kyle Mullins

require_relative '../services/user_code_service'

module UserCode
  attr_reader :id

  def initialize(field_id_map, *fields)
    @id = UserCodeService.instance.generate_code_id
    @field_id_map = field_id_map
    @code_block = Proc.new if block_given?

    register
    fields.each do |field|
      register_for_field(@field_id_map[field])
    end
  end

  protected

  def register_for_field(field_id)
    UserCodeService.instance.register_for_field(@id, field_id)
  end

  def generate_field_getter(context, getter_name, field_id)
    value = 7
    #value = FieldService.instance.get_field(field_id).widget.value

    context.instance_eval <<-CODE
      def #{getter_name}
        #{value}
      end
    CODE
  end

  def generate_field_setter(context, field, field_id)
    context.instance_eval <<-CODE
      def #{field}=(value)
        ::FieldService.instance.get_field(#{field_id}).widget.value = value
      end
    CODE
  end
end