module Uncouple
  class Action

    attr_reader :params

    def initialize(params=nil)
      @params = recast_parameters(params)
    end

    def perform
      raise NotImplementedError, "Overwrite `perform` in your action. Params: #{params}"
    end

    def success?
      @success
    end

    def failure?
      !success?
    end

  private

    def recast_parameters(params)
      return if params.nil?
      if defined?(ActionController::Parameters)
        recast_as_strong_parameters(params)
      elsif defined?(ActiveSupport::HashWithIndifferentAccess)
        recast_as_indifferent_parameters(params)
      else
        params
      end
    end

    def recast_as_strong_parameters(params)
      params.is_a?(ActionController::Parameters) ? params : ActionController::Parameters.new(params)
    end

    def recast_as_indifferent_parameters(params)
      params.is_a?(ActiveSupport::HashWithIndifferentAccess) ? params : ActiveSupport::HashWithIndifferentAccess.new(params)
    end

  end
end
