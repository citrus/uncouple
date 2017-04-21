module Uncouple
  class Action
    module Authorization

      def perform_with_authorization
        perform if authorize!
      end

      def authorize!
        # overwrite me!
        true
      end

      def current_user
        @current_user ||= params.delete(:current_user)
      end

    end
  end
end
