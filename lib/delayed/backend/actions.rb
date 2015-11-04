module Delayed
  module Backend
    module Ironmq
      module Actions
        def field(name, options = {})
          #type   = options[:type]    || String
          default = options[:default] || nil
          define_method name do
            @attributes ||= {}
            @attributes[name.to_sym] || default
          end
          define_method "#{name}=" do |value|
            @attributes ||= {}
            @attributes[name.to_sym] = value
          end
        end

        def before_fork
        end

        def after_fork
        end

        def db_time_now
          Time.now.utc
        end

        #def self.queue_name
        #  Delayed::Worker.queue_name
        #end

        # No need to check locks
        def clear_locks!(*args)
          true
        end

        private

        def ironmq
          ::Delayed::IronMqBackend.ironmq
        end

        def queue_name(queue, priority)
          "#{queue}_#{priority || 0}"
        end
      end
    end
  end
end
