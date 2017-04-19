require "spec_helper"

RSpec.describe Uncouple::Action do

  let(:params) do
    { controller: "application", action: "index" }
  end

  let(:action) do
    Uncouple::Action.new(params)
  end

  describe "#initialize" do

    it "initializes with params when strong parameters is not present" do
      expect(ActionController::Parameters).to receive(:new).and_return(params)
      expect(action.params).to eq(params)
    end

    it "initializes and converts params to strong parameters" do
      strong_params = ActionController::Parameters.new(params)
      expect(action.params).to eq(strong_params)
    end

  end

  describe "#perform" do

    it "raises not implemented error" do
      expect { action.perform }.to raise_error(NotImplementedError)
    end

  end

  describe "#success?" do

    it "returns falsey by default" do
      expect(action.success?).to_not be(true)
    end

    it "returns true when @success ivar is set" do
      action.instance_variable_set("@success", true)
      expect(action.success?).to be(true)
    end

  end

  describe "#failure?" do

    it "returns the opposite of success?" do
      expect(action).to receive(:success?).and_return(false)
      expect(action.failure?).to be(true)
      expect(action).to receive(:success?).and_return(true)
      expect(action.failure?).to be(false)
    end

  end

end
