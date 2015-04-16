# sheet_translator.rb
#
# Author::	Kyle Mullins

require_relative '../services/sheet_service'
require_relative '../services/field_service'

class SheetTranslator
  def parse_sheet(raw_sheet)

  end

  def serialize_sheet(sheet_id)
    fields = FieldService.instance.get_fields_for_sheet(sheet_id)
  end
end