require "spec_helper"
require "uncouple/action/instrumentation"

Uncouple::Action.send(:extend, Uncouple::Action::Instrumentation)

RSpec.describe Uncouple::Action::Instrumentation do

  class InstrumentedAction < Uncouple::Action
    def perform; end
    def authorize!; end
  end

  describe ".method_added" do

    it "calls to alias the new method" do
      [ :perform, :authorize! ].each do |method|
        expect(InstrumentedAction).to receive(:alias_with_instrumentation).with(method)
        InstrumentedAction.send(:method_added, method)
      end
    end

    it "does nothing for other methods" do
      expect(InstrumentedAction).to receive(:alias_with_instrumentation).never
      InstrumentedAction.send(:method_added, :something)
    end

  end

  describe ".alias_with_instrumentation" do

    it "does nothing when the instrumented method is already defined" do
      expect(InstrumentedAction).to receive(:define_method).never
      expect(InstrumentedAction.alias_with_instrumentation(:perform)).to be_nil
    end

    it "defines new instrumented method" do
      InstrumentedAction.send(:undef_method, :perform_with_instrumentation)
      expect(InstrumentedAction).to receive(:define_method).with(:perform_with_instrumentation)
      expect(InstrumentedAction).to receive(:alias_method).twice
      InstrumentedAction.alias_with_instrumentation(:perform)
    end

  end

end
