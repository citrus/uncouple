require "spec_helper"
require "uncouple/action/instrumentation_hook"

RSpec.describe Uncouple::Action::InstrumentationHook do

  class InstrumentedAction < Uncouple::Action
    def perform; end
  end

  describe ".method_added" do

    it "includes action instrumentation as perform is defined" do
      expect(InstrumentedAction).to receive(:included_modules).and_return([])
      expect(InstrumentedAction).to receive(:include).with(::Uncouple::Action::Instrumentation)
      InstrumentedAction.send(:method_added, :perform)
    end

  end

end
