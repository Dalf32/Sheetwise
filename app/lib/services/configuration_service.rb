# configuration_service.rb
#
# Author::	Kyle Mullins

require 'singleton'

class ConfigurationService
  include Singleton

  def set_configuration(config)
    fail 'Cannot overwrite Configuration' unless @config.nil?

    @config = config
  end

  def method_missing(method, *args)
    if @config.nil? || is_setter?(method)
      super
    elsif args.size <= 1
      @config.public_send(method, *args)
    else
      super
    end
  end

  def respond_to_missing?(method, *)
    if @config.nil? || is_setter?(method)
      super
    else
      @config.respond_to?(method)
    end
  end

  private

  def is_setter?(method)
    !!(method =~ /^set|([^=+]=)$/)
  end
end