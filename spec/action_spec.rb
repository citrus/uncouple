require "spec_helper"

RSpec.describe Uncouple::Action do

  let(:params) do
    { controller: "application", action: "index" }
  end

  let(:action) do
    Uncouple::Action.new(params)
  end

  describe "#initialize" do

    it "initializes with params" do
      expect(action.params).to eq(params)
    end

  end

  describe "#perform" do

    it "raises not implemented error" do
      expect { action.perform }.to raise_error(NotImplementedError)
    end

  end

end
