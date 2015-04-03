# sheetwise_window.rb
#
# Author::  Kyle Mullins

require 'tk'

require_relative 'sheet'
require_relative 'controls/labeled_field'
require_relative '../services/sheet_service'
require_relative '../data/definition_file_translator'
require_relative '../data/local_repository'
require_relative '../utilities/notification'

class SheetwiseWindow
	def initialize(win_width, win_height, model)
		root = TkRoot.new do
			title 'Sheetwise'
			geometry "#{win_width}x#{win_height}"
		end

		create_menu(root)
		create_components(root)

    @model = model
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
    file_menu.add(:command, label: 'Close Sheet', command: proc{ close_sheet })
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

    def_hash = @model.get_definition_hash('test')

    notification = Notification.new
		sheet = SheetService.instance.create_sheet(def_hash, &Notification.aggregator(notification))

    if notification.has_errors?
      Tk::messageBox(title: 'Error', type: 'ok', icon: 'error',
          message: 'An error occurred and the Sheet cannot be opened:', detail: notification.format_messages)
      return
    end

    @tabs.add(new_tab, text: sheet.name)
    @tabs.select(new_tab)
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

  def close_sheet
    selected_tab = @tabs.selected
    #TODO: Create a Frame subclass that holds a sheet_id and knows how to format itself like a Sheet

    unless selected_tab.nil?
      #SheetService.instance.remove_sheet(selected_tab.sheet_id)
      @tabs.forget(selected_tab)
    end
  end

	def exit(window_root)
		window_root.destroy
	end

	def external_storage_settings
		puts 'external storage settings'
	end
end
