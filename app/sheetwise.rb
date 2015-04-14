# sheetwise.rb
#
# Author::  Kyle Mullins

require 'optparse'
require_relative 'lib/ui/sheetwise_window'
require_relative 'lib/data/configuration_file_translator'
require_relative 'lib/data/default_configuration'
require_relative 'lib/data/repository_manager'
require_relative 'lib/data/local_repository'
require_relative 'lib/services/configuration_service'

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

notification = Notification.new
config_translator = ConfigurationFileTranslator.new(config_file)
config = config_translator.read_config_with_default(DEFAULT_CONFIG, &Notification.aggregator(notification))

$stderr.puts notification.format_messages if notification.has_errors?
notification.clear_errors

abort if config.nil?

unless config.version.start_with?(VERSION_STRING[0..-(PATCH_VERSION.size + 1)])
	abort "Configuration file out of date!\n\tSheetwise version: #{VERSION_STRING}\n\tConfiguration version: #{config.version}"
end

ConfigurationService.instance.set_configuration(config)
repository_manager = RepositoryManager.new

config.repositories.each{|source|
  #TODO: differentiate between local and remote sources
  repository_manager.add_source(LocalRepository.new(source))
}

#TODO: create actual model and pass that instead of the DefinitionFileTranslator
#TODO: also pass actual Configuration object to model so it can be mutated
window = SheetwiseWindow.new(config.window_width, config.window_height, repository_manager)
window.show

config_translator.write_config(config, &Notification.aggregator(notification))
$stderr.puts notification.format_messages if notification.has_errors?
