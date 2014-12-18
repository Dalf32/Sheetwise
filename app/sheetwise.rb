# sheetwise.rb
#
# Author::  Kyle Mullins

require_relative 'lib/ui/sheetwise_window'
require_relative 'lib/data/configuration_file_translator'

#MAIN

MAJOR_VERSION = '0'
MINOR_VERSION = '0'
PATCH_VERSION = '1'
VERSION_STRING = MAJOR_VERSION + '.' + MINOR_VERSION + '.' + PATCH_VERSION

#TODO: Configuration options
# storage service details

#TODO: Command-line options
# launch with sheet(s) (local)
# alternate settings file

config_translator = ConfigurationFileTranslator.new('.sheetwise')
config = config_translator.read_config

unless config.version.start_with?(VERSION_STRING[0..-(PATCH_VERSION.size + 1)])
	abort "Configuration file out of date!\n\tSheetwise version: #{VERSION_STRING}\n\tConfiguration version: #{config.version}"
end

window = SheetwiseWindow.new(config.window_width, config.window_height)
window.show

config_translator.write_config(config)
