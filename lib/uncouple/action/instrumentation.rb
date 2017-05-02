module Uncouple
  class Action
    module Instrumentation

      def self.included(base)
        base.class_eval do
          alias perform_without_instrumentation perform
          alias perform perform_with_instrumentation
        end
      end

      def perform_with_instrumentation
        ActiveSupport::Notifications.instrument "#{self.class.to_s}.perform", params do
          perform_without_instrumentation
        end
      end

    end
  end
end
