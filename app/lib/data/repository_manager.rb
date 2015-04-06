# repository_manager.rb
#
# Author::	Kyle Mullins

require_relative 'definition_translator'

class RepositoryManager
  def initialize
    @sources = {}
  end

  def add_source(source)
    #TODO: Give repos names and map from name to repo
    @sources[source.display_name] = source
  end

  def has_definition?(definition_name)
    @sources.any? { |definition| definition.contains?(definition_name) }
  end

  def get_definition(definition_name)
    definition = find_definition(definition_name)
    DefinitionTranslator.parse_definition(definition) unless definition.nil?
  end

  private

  def find_definition(definition_name)
    @sources.each_value do |source|
      if source.contains?(definition_name)
        definition = source.retrieve_definition(definition_name)

        return definition unless definition.nil?
      end
    end

    nil
  end
end