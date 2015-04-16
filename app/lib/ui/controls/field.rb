# field.rb
#
# Author::  Kyle Mullins

require 'tk'
require_relative 'widgets/all_widgets'
require_relative '../../data/definition_constants'

class Field
	include Constants
	
	attr_reader :field_type, :Widgets

	def initialize(field_type, initial_value, options_hash)
		@field_type = field_type
		@initial_value = initial_value
		@options = options_hash
		@Widgets = nil
		@validated = true
	end

	def show_control(parent, row = nil, col = nil)
		@options[GRID_ROW] = row unless row.nil?
		@options[GRID_COL] = col unless col.nil?

    #TODO: Validate field_type before we get this far
		case @field_type.to_sym
			when Fields::HEADER
				@options[Widgets::Label::STYLE_KEY] = Widgets::Label::HEADING_STYLE
				@Widgets = LabelWidget.new(parent, @options)
			when Fields::LABEL
				@options[Widgets::Label::STYLE_KEY] = Widgets::Label::NORMAL_STYLE
				@Widgets = LabelWidget.new(parent, @options)
			when Fields::TEXT
				@options[Widgets::Text::MULTILINE_KEY] = false
				@Widgets = TextWidget.new(parent, @options)
			when Fields::MULTILINE
				@options[Widgets::Text::MULTILINE_KEY] = true
				@Widgets = TextWidget.new(parent, @options)
			when Fields::NUMERIC
				@Widgets = NumericWidget.new(parent, @options)
			when Fields::LISTBOX
				choices = @options[Widgets::Listbox::CHOICES_KEY]
				@Widgets = ListboxWidget.new(parent, choices, @options)
			when Fields::CHECKBOX
				text = @options[Widgets::Checkbox::TEXT_KEY]
				@Widgets = CheckboxWidget.new(parent, text, @options)
			else
				fail "Invalid field type: #{@field_type}"
		end

		@Widgets.value = @initial_value.nil? ? @Widgets.default_value : @initial_value
	end

	def mark_validated(was_validated)
		#TODO: perhaps change @validated to :passed, :failed, :awaiting_validation
		@validated = was_validated
	end

	def validated?
		@validated and not @Widgets.dirty?
	end

	def dup

	end
end
