# sheet_translator.rb
#
# Author::	Kyle Mullins

require 'json'
require_relative 'constants'
require_relative '../services/sheet_service'
require_relative '../services/field_service'

class SheetTranslator
  def self.parse_sheet(raw_sheet)

  end

  def self.serialize_sheet(sheet_id)
    sheet = SheetService.instance.get_sheet(sheet_id)
    fields = FieldService.instance.get_fields_for_sheet(sheet_id)
    field_map = fields.inject({}){ |hash, field| hash[field.name] = field.widget.value }

    sheet_hash = {
        Constants::NAME => sheet.name,
        Constants::Sheets::TITLE => sheet.title,
        Constants::Sheets::FIELDS => field_map
    }

    JSON.pretty_generate(sheet_hash)
  end
end