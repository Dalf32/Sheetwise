# field.rb
#
# Author::  Kyle Mullins

require 'tk'
require_relative 'widgets/all_widgets'

class Field
	HEADER = :header
	LABEL = :label
	TEXT = :text
	MULTILINE = :multiline
	NUMERIC = :numeric
	LISTBOX = :listbox
	CHECKBOX = :checkbox

	attr_reader :field_type, :widget

	def initialize(field_type, initial_value, options_hash)
		@field_type = field_type
		@initial_value = initial_value
		@options = options_hash
		@widget = nil
		@validated = true
	end

	def show_control(parent, row = nil, col = nil)
		@options[Widget::GRID_ROW_KEY] = row unless row.nil?
		@options[Widget::GRID_COL_KEY] = col unless col.nil?

		case @field_type
			when HEADER
				@options[LabelWidget::STYLE_KEY] = LabelWidget::HEADING_STYLE
				@widget = LabelWidget.new(parent, @options)
			when LABEL
				@options[LabelWidget::STYLE_KEY] = LabelWidget::NORMAL_STYLE
				@widget = LabelWidget.new(parent, @options)
			when TEXT
				@options[TextWidget::MULTILINE_KEY] = false
				@widget = TextWidget.new(parent, @options)
			when MULTILINE
				@options[TextWidget::MULTILINE_KEY] = true
				@widget = TextWidget.new(parent, @options)
			when NUMERIC
				@widget = NumericWidget.new(parent, @options)
			when LISTBOX
				choices = @options[ListboxWidget::CHOICES_KEY]
				@widget = ListboxWidget.new(parent, choices, @options)
			when CHECKBOX
				text = @options[CheckboxWidget::TEXT_KEY]
				@widget = CheckboxWidget.new(parent, text, @options)
			else
				fail "Invalid field type: #{@field_type}"
		end

		@widget.value = @initial_value
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
