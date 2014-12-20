# configuration.rb
#
# Author::  Kyle Mullins

require_relative 'extensions/hash_extensions'

class Configuration
	def initialize(config_hash = {}, fallback_config = {})
		@config = config_hash.symbolize_keys
		@fallback_config = fallback_config.symbolize_keys
	end

	def set(key, value)
		@config[key] = value
	end

	def get(key)
		@config.fetch(key) do
			@fallback_config.fetch(key){ fail "Key not found in configuration: #{key}" }
		end
	end

	def has_key?(key)
		@config.has_key?(key) or @fallback_config.has_key?(key)
	end

	def to_h
		@config.dup
	end

	def method_missing(config_key, *args)
		if args.empty?
			get(config_key)
		elsif args.size == 1
			set(config_key, args.first)
		else
			super
		end
	end

	alias_method :to_hash, :to_h
end
