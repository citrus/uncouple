module Uncouple
  class Action

    attr_reader :params

    def initialize(params={})
      @params = params
    end

    def perform
      raise NotImplementedError, "Overwrite `perform` in your action. Params: #{params}"
    end

    def success?
      @success
    end

  end
end
