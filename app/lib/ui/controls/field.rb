# field.rb
#
# Author::  Kyle Mullins

require 'tk'
require_relative 'widgets/all_widgets'
require_relative '../../data/definition_constants'

class Field
	attr_reader :field_type, :widget

	def initialize(field_type, initial_value, options_hash)
		@field_type = field_type
		@initial_value = initial_value
		@options = options_hash
		@widget = nil
		@validated = true
	end

	def show_control(parent, row = nil, col = nil)
		@options[Constants::GRID_ROW] = row unless row.nil?
		@options[Constants::GRID_COL] = col unless col.nil?

    #TODO: Validate field_type before we get this far
		case @field_type.to_sym
			when Constants::Field::HEADER
				@options[Constants::Widget::Label::STYLE_KEY] = Constants::Widget::Label::HEADING_STYLE
				@widget = LabelWidget.new(parent, @options)
			when Constants::Field::LABEL
				@options[Constants::Widget::Label::STYLE_KEY] = Constants::Widget::Label::NORMAL_STYLE
				@widget = LabelWidget.new(parent, @options)
			when Constants::Field::TEXT
				@options[Constants::Widget::Text::MULTILINE_KEY] = false
				@widget = TextWidget.new(parent, @options)
			when Constants::Field::MULTILINE
				@options[Constants::Widget::Text::MULTILINE_KEY] = true
				@widget = TextWidget.new(parent, @options)
			when Constants::Field::NUMERIC
				@widget = NumericWidget.new(parent, @options)
			when Constants::Field::LISTBOX
				choices = @options[Constants::Widget::Listbox::CHOICES_KEY]
				@widget = ListboxWidget.new(parent, choices, @options)
			when Constants::Field::CHECKBOX
				text = @options[Constants::Widget::Checkbox::TEXT_KEY]
				@widget = CheckboxWidget.new(parent, text, @options)
			else
				fail "Invalid field type: #{@field_type}"
		end

		@widget.value = @initial_value.nil? ? @widget.default_value : @initial_value
	end

	def mark_validated(was_validated)
		#TODO: perhaps change @validated to :passed, :failed, :awaiting_validation
		@validated = was_validated
	end

	def validated?
		@validated and not @widget.dirty?
	end

	def dup

	end
end
