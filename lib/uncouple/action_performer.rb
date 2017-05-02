module Uncouple
  module ActionPerformer

    def perform(action_class, action_params=nil, &block)
      action_params ||= params if respond_to?(:params)
      action_params = params_with_current_user(action_params)
      if @action = action_class.new(action_params)
        @action.perform_with_authorization
        block.call if block_given? && @action.success?
      end
      @action
    end

    def params_with_current_user(params)
      return params if params.nil? || !respond_to?(:current_user)
      params.merge(current_user: current_user)
    end

  end
end
