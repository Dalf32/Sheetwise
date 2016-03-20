# sheetwise_window.rb
#
# Author::  Kyle Mullins

require 'tk'

require_relative 'sheet'
require_relative 'controls/labeled_field'
require_relative 'controls/sheet_frame'
require_relative '../services/sheet_service'
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
		create_file_menu_opts(root, file_menu)

		settings_menu = TkMenu.new(menubar)
		menubar.add(:cascade, menu: settings_menu, label: 'Settings')
    create_settings_menu_opts(settings_menu)
	end

  def create_file_menu_opts(root, file_menu)
    file_menu.add(:command, label: 'New Sheet...', command: proc{ new_sheet })
    file_menu.add(:command, label: 'Open Sheet...', command: proc{ open_sheet })
    file_menu.add(:command, label: 'Save', command: proc{ save })
    file_menu.add(:command, label: 'Save As...', command: proc{ save_as })
    file_menu.add(:command, label: 'Close Sheet', command: proc{ close_sheet })
    file_menu.add(:command, label: 'Exit', command: proc{ exit(root) })
  end

  def create_settings_menu_opts(settings_menu)
    settings_menu.add(:command, label: 'External Storage')
  end

	def create_components(root)
		@tabs = Tk::Tile::Notebook.new(root) do
			pack padx: 1, pady: 1, fill: 'both', expand: 1
		end
	end

	private

	def new_sheet
    #TODO: Present custom dialog allowing user to browse definition repos and pick one
    definition = @model.get_definition('test')

    notification = Notification.new
		sheet = SheetService.instance.create_sheet(definition.structure, &Notification.aggregator(notification))
    UserCodeService.instance.create_user_code(definition.code_block, sheet.id, &Notification.aggregator(notification))

    if notification.has_errors?
      Tk::messageBox(title: 'Error', type: 'ok', icon: 'error',
          message: 'An error occurred and the Sheet cannot be opened:', detail: notification.format_messages)
      return
    end

    new_tab = SheetFrame.new(@tabs, sheet.id)

    @tabs.add(new_tab, text: sheet.name)
    @tabs.select(new_tab)
		sheet.display_sheet(new_tab)
	end

	def open_sheet
		puts Tk::getOpenFile(defaultextension: '.sheet', filetypes: [['Sheet files', '.sheet']])
	end

	def save(selected_tab = @tabs.selected)
		#TODO: Check dirty state of selected sheet and do nothing unless dirty
		if false #SheetService.instance.has_file_location?(selected_tab.sheet_id)
			#TODO: Perform save operation
		else
			save_as(selected_tab)
		end
	end

	def save_as(selected_tab = @tabs.selected)
		unless selected_tab.nil?
			sheet = get_sheet(selected_tab)
			puts Tk::getSaveFile(defaultextension: '.sheet', filetypes: [['Sheet files', '.sheet']], initialfile: "#{sheet.title}.sheet")
		end
	end

  def close_sheet(selected_tab = @tabs.selected)
    unless selected_tab.nil?
      #TODO: Check dirty state of selected sheet and prompt if dirty
      SheetService.instance.remove_sheet(selected_tab.sheet_id)
      @tabs.forget(selected_tab)
    end
  end

	def exit(window_root)
    @tabs.tabs.each do |tab|
      close_sheet(tab)
    end

		window_root.destroy
	end

	def external_storage_settings
		puts 'external storage settings'
	end

	def get_sheet(tab = @tabs.selected)
		SheetService.instance.get_sheet(tab.sheet_id) unless tab.nil?
	end
end
