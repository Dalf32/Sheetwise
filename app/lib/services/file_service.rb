# file_service.rb
#
# Author::	Kyle Mullins

require 'singleton'

class FileService
  include Singleton

  def open_sheet(sheet_path)
    if sheet_path.readable?
      sheet_text = sheet_path.read
      sheet_hash = SheetTranslator.parse_sheet(sheet_text)
      SheetService.instance.create_sheet(sheet_hash)
    end
  end

  def save_sheet(sheet_id)

  end

  def close_sheet(sheet_id)

  end

  private

  def initialize
    @open_sheet_files = {}
  end
end