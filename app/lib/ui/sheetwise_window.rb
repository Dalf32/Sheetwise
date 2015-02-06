# sheetwise_window.rb
#
# Author::  Kyle Mullins

require 'tk'

require_relative 'sheet'
require_relative 'controls/labeled_field'

class SheetwiseWindow
	def initialize(win_width, win_height)
		root = TkRoot.new do
			title 'Sheetwise'
			geometry "#{win_width}x#{win_height}"
		end

		create_menu(root)
		create_components(root)
	end

	def show
		Tk.mainloop
	end

	private

	def create_menu(root)
		TkOption.add('*tearOff', 0)

		menubar = TkMenu.new(root)
		root['menu'] = menubar

		file_menu = TkMenu.new(menubar)
		menubar.add(:cascade, menu: file_menu, label: 'File')
		file_menu.add(:command, label: 'New Sheet...', command: proc{ new_sheet })
		file_menu.add(:command, label: 'Open Sheet...', command: proc{ open_sheet })
		file_menu.add(:command, label: 'Save', command: proc{ save })
		file_menu.add(:command, label: 'Save As...', command: proc{ save_as })
		file_menu.add(:command, label: 'Exit', command: proc{ exit(root) })

		settings_menu = TkMenu.new(menubar)
		menubar.add(:cascade, menu: settings_menu, label: 'Settings')
		settings_menu.add(:command, label: 'External Storage')
	end

	def create_components(root)
		@tabs = Tk::Tile::Notebook.new(root) do
			pack padx: 1, pady: 1, fill: 'both', expand: 1
		end
	end

	private

	def new_sheet
		new_tab = Tk::Tile::Frame.new(@tabs) do
			pack padx: 1, pady: 1, fill: 'both'
			relief 'sunken'
		end

		@tabs.add(new_tab, text: 'New Tab')
		@tabs.select(new_tab)

		sheet = Sheet.new(1, 'New Sheet')
		sheet_section = SheetSection.new({})

		sheet_section.add_control(0, 0, Field.new(Field::LABEL, 'Test Section', {}))
		sheet_section.add_control(1, 0, Field.new(Field::TEXT, 'Test text', {}))
		sheet_section.add_control(2, 0, LabeledField.new(Field::TEXT, 'Name', '', {}))

		sheet_section.add_control(0, 1, Field.new(Field::CHECKBOX, CheckboxWidget::CHECKED, { CheckboxWidget::TEXT_KEY => 'Is true?' }))
		sheet_section.add_control(1, 1, Field.new(Field::MULTILINE, '', {}))
		sheet_section.add_control(2, 1, Field.new(Field::LISTBOX, 'B', { ListboxWidget::CHOICES_KEY => %w(A B C) }))

		sheet.set_controls(sheet_section)
		sheet.display_sheet(new_tab)
	end

	def open_sheet
		puts 'open_sheet'
	end

	def save
		puts 'save'
	end

	def save_as
		puts 'save_as'
	end

	def exit(window_root)
		window_root.destroy
	end

	def external_storage_settings
		puts 'external storage settings'
	end
end
