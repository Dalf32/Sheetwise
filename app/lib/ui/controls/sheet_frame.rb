# sheet_frame.rb
#
# Author::	Kyle Mullins

require 'tk'

class SheetFrame < Tk::Tile::Frame
  attr_reader :sheet_id

  def initialize(parent, sheet_id)
    @sheet_id = sheet_id

    super(parent) do
      pack padx: 1, pady: 1, fill: 'both'
      relief 'sunken'
    end
  end
end