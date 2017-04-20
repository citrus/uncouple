module Uncouple
  module ActionPerformer

    def perform(action_class, action_params=nil, &block)
      action_params ||= params if respond_to?(:params)
      action_params.merge!(current_user: current_user) if respond_to?(:current_user)
      if @action = action_class.new(action_params)
        @action.perform
        block.call if block_given? && @action.success?
      end
      @action
    end

  end
end
