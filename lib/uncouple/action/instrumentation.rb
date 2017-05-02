module Uncouple
  class Action
    module Instrumentation

      def method_added(method)
        case method
        when :perform, :authorize!
          alias_with_instrumentation(method)
        end
      end

      def alias_with_instrumentation(method)

        method_without_instrumentation = "#{method}_without_instrumentation".to_sym
        method_with_instrumentation = "#{method}_with_instrumentation".to_sym

        return if instance_methods.include?(method_with_instrumentation)

        define_method method_with_instrumentation do
          ActiveSupport::Notifications.instrument "#{self.class.to_s}##{method}", params do
            send(method_without_instrumentation)
          end
        end

        alias_method method_without_instrumentation, method
        alias_method method, method_with_instrumentation

      end

    end
  end
end
