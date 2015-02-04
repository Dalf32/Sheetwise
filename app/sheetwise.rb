# sheetwise.rb
#
# Author::  Kyle Mullins

require 'optparse'
require_relative 'lib/ui/sheetwise_window'
require_relative 'lib/data/configuration_file_translator'
require_relative 'lib/data/default_configuration'

#MAIN

MAJOR_VERSION = '0'
MINOR_VERSION = '0'
PATCH_VERSION = '1'
VERSION_STRING = MAJOR_VERSION + '.' + MINOR_VERSION + '.' + PATCH_VERSION

#TODO: Configuration options
# storage service details

config_file = '.sheetwise'
starting_sheets = []

OptionParser.new do |opt|
	opt.on('-f', '--config_file=FILE', 'Specify an alternate configuration file.'){|file| config_file = file }

	#TODO: launch with sheet(s) (local)
	opt.on('-s', '--sheet=FILE',
			'Specify a Sheet file to be opened upon program start. This option may be provided multiple times.'){|sheet| starting_sheets<<sheet }
end.parse!

config_translator = ConfigurationFileTranslator.new(config_file)
config = config_translator.read_config_with_default(DEFAULT_CONFIG) do |notif| $stderr<<notif.format_messages<<"\n" end

abort if config.nil?

unless config.version.start_with?(VERSION_STRING[0..-(PATCH_VERSION.size + 1)])
	abort "Configuration file out of date!\n\tSheetwise version: #{VERSION_STRING}\n\tConfiguration version: #{config.version}"
end

window = SheetwiseWindow.new(config.window_width, config.window_height)
window.show

config_translator.write_config(config) do |notif| $stderr<<notif.format_messages<<"\n" end
