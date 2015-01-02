# configuration.rb
#
# Author::  Kyle Mullins

require_relative '../utilities/extensions/hash_extensions'

class Configuration
	def initialize(config_hash = {}, fallback_config = {})
		@config = normalize_hash(config_hash)
		@fallback_config = normalize_hash(fallback_config)
	end

	def set(key, value)
		@config[key] = value
	end

	def get(key)
		@config.fetch(key) do
			@fallback_config.fetch(key) do fail "Key not found in configuration: #{key}" end
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

	private

	def normalize_hash(hash)
		hash.transform_keys(&Transforms::Normalize)
	end
end
