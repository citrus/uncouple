require "spec_helper"
require "uncouple/action/instrumentation"

RSpec.describe Uncouple::Action::Instrumentation do

  class InstrumentedAction < Uncouple::Action
    def perform; end
  end

  before do
    InstrumentedAction.send(:include, Uncouple::Action::Instrumentation)
  end

  describe ".included" do

    it "aliases perform to perform_without_instrumentation" do
      expect(InstrumentedAction.instance_methods).to include(:perform_without_instrumentation)
    end

    it "adds perform_with_instrumentation method" do
      expect(InstrumentedAction.instance_methods).to include(:perform_with_instrumentation)
    end

  end

  describe "#perform_with_instrumentation" do

    let(:action) { InstrumentedAction.new }

    it "calls to instrument method" do
      expect(ActiveSupport::Notifications).to receive(:instrument).with("InstrumentedAction.perform", {})
      action.perform_with_instrumentation
    end

    it "calls unaliased perform method" do
      expect(action).to receive(:perform_without_instrumentation)
      action.perform_with_instrumentation
    end

  end

end
