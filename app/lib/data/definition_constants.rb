# definition_constants.rb
#
# Author::  Kyle Mullins

module Constants
	NAME = :name
	CONTROL_LIST = :controls
	VALIDATOR_LIST = :validators
	CALCULATOR_LIST = :calculators

	FIELD_TYPE = :type
  SUB_FIELD_TYPE = :subtype
	FIELD_VALUE = :value
  SUB_FIELD_VALUE = :subvalue
	GRID_ROW = :row
	GRID_COL = :col
  SECTION = :section

  module Fields
    HEADER = :header
    LABEL = :label
    TEXT = :text
    MULTILINE = :multiline
    NUMERIC = :numeric
    LISTBOX = :listbox
    CHECKBOX = :checkbox

    module Table
      HEADERS_KEY = :headers
      SHOW_HEADERS = :show
      HIDE_HEADERS = :hide
    end
  end

  module Widgets
    module Checkbox
      TEXT_KEY = :text
      CHECKED = 'checked'
      UNCHECKED = 'unchecked'
    end

    module Label
      STYLE_KEY = :style
      HEADING_STYLE = :heading
      NORMAL_STYLE = :normal
    end

    module Listbox
      CHOICES_KEY = :choices
    end

    module Text
      MULTILINE_KEY = :is_multiline
      READONLY_KEY = :is_readonly
    end
  end

  module Listing
    NAME = 'name'
    DEFINITIONS = 'definitions'
    EXCLUSIONS = 'exclusions'
  end
end

Constants.freeze
