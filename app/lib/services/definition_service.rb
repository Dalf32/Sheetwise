# definition_service.rb
#
# Author::	Kyle Mullins

class DefinitionService
  def create_controls(definition_hash)
    notif_block = block_given? ? Proc.new : ->{}

    control_ids = []
    root_section = recursively_create_controls(definition_hash, 'root', control_ids, &notif_block)

    if root_section.nil? || control_ids.empty?
      notif_block.call Notification.create_error('Failed to create Sheet.')
      return nil
    end

    [root_section, control_ids]
  end

  private

  def recursively_create_controls(def_hash, section_name, control_ids, &notif_block)
    if section_name.nil?
      yield Notification.create_error("Section not created, 'Name' is required.")
      return nil
    end

    section = SheetSection.new({})

    def_hash[CONTROL_LIST].each do |control_hash|
      control_type = control_hash[FIELD_TYPE]

      if control_type == SECTION
        control = recursively_create_controls(control_hash, control_hash[NAME], control_ids, &notif_block)
      else
        control_id, control = *FieldService.instance.create_field(control_hash, &notif_block)
      end

      row = control_hash[GRID_ROW]
      col = control_hash[GRID_COL]

      if row.nil? || col.nil?
        yield Notification.create_error("Control not added to Section: #{section_name}, 'Row' and 'Col' are required.")
        next
      elsif control_id.nil?
        yield Notification.create_error("Control not added to Section: #{section_name}, creation failed.")
        next
      end

      section.add_control(row, col, control)
      control_ids<<control_id
    end

    section
  end
end