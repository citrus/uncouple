require "uncouple/action/instrumentation"

module Uncouple
  class Action
    module InstrumentationHook

      def method_added(method)
        if method == :perform && included_modules.exclude?(::Uncouple::Action::Instrumentation)
          send(:include, ::Uncouple::Action::Instrumentation)
        end
      end

    end
  end
end

Uncouple::Action.send(:extend, Uncouple::Action::InstrumentationHook)
