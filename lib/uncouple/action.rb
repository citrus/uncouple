module Uncouple
  class Action

    attr_reader :params

    def initialize(params=nil)
      @params = convert_to_strong_parameters(params)
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

    def convert_to_strong_parameters(params)
      return if params.nil?
      return params unless defined?(ActionController::Parameters)
      return params if params.is_a?(ActionController::Parameters)
      ActionController::Parameters.new(params)
    end

  end
end
