# sheetwise_window.rb
#
# Author::  Kyle Mullins

require 'tk'

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
		file_menu.add(:command, label: 'Exit', command: proc{ exit })

		settings_menu = TkMenu.new(menubar)
		menubar.add(:cascade, menu: settings_menu, label: 'Settings')
		settings_menu.add(:command, label: 'External Storage')
	end

	def create_components(root)
		@tabs = Tk::Tile::Notebook.new(root) do
			pack padx: 1, pady: 1, fill: 'both', expand: 1
		end

		test_tab = Tk::Tile::Frame.new(@tabs) do
			pack padx: 1, pady: 1, fill: 'both'
			relief 'sunken'
		end

		@tabs.add(test_tab, text: 'Test')
	end

	private

	def new_sheet
		puts 'new sheet'
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

	def exit
		puts 'exit'
	end

	def external_storage_settings
		puts 'external storage settings'
	end
end
