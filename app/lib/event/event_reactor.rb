# event_reactor.rb
#
# Author::  Kyle Mullins

require 'singleton'

class EventReactor
	include Singleton

	def subscribe_by_type(*types, &block)
		types.each do |event_type|
			@type_subscriptions[event_type]<<block
		end
	end

	def subscribe_by_tag(*tags, &block)
		tags.each do |tag|
			@tag_subscriptions[tag]<<block
		end
	end

	def publish(event, *tags)
		@queue_mutex.synchronize do
			@event_queue<<EventWithTags.new(event, tags)
		end
	end

	private

	TICK_INTERVAL = 0.1
	EventWithTags = Struct.new(:event, :tags)

	def initialize
		@event_queue = []
		@type_subscriptions = Hash.new{|subs, type| subs[type] = [] }
		@tag_subscriptions = Hash.new{|subs, tag| subs[tag] = [] }
		@event_dispatch_thread = Thread.new{ dispatch_events }
		@queue_mutex = Mutex.new
	end

	def dispatch_events
		while true
			sleep(TICK_INTERVAL)

			@queue_mutex.synchronize do
				@event_queue.delete_if do |event_with_tags|
					event = event_with_tags.event
					tags = event_with_tags.tags
					was_event_dispatched = false

					@type_subscriptions[event.class].each do |block|
						block.call(event)
						was_event_dispatched = true
					end

					tags.each do |tag|
						@tag_subscriptions[tag].each do |block|
							block.call(event)
							was_event_dispatched = true
						end
					end

					was_event_dispatched
				end
			end
		end
	end
end
