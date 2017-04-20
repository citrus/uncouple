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
      hide_const("ActionController::Parameters")
      hide_const("ActiveSupport::HashWithIndifferentAccess")
      expect(action.params).to eq(params)
    end

    it "initializes and converts params to strong parameters" do
      strong_params = ActionController::Parameters.new(params)
      expect(action.params).to eq(strong_params)
      expect(action.params).to be_a(ActionController::Parameters)
    end

    it "initializes and converts params to hash with indifferent access" do
      hide_const("ActionController::Parameters")
      indifferent_params = ActiveSupport::HashWithIndifferentAccess.new(params)
      expect(action.params).to eq(indifferent_params)
      expect(action.params).to be_a(ActiveSupport::HashWithIndifferentAccess)
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

  describe "#current_user" do

    User = Struct.new(:email)

    let(:user) { User.new("test@example.com") }

    it "returns nil by default" do
      expect(action.current_user).to be_nil
    end

    it "returns user passed in by params" do
      action.params.merge!(current_user: user)
      expect(action.current_user).to eq(user)
    end

    it "delete current_user from params" do
      action.params.merge!(current_user: user)
      action.current_user
      expect(action.params[:current_user]).to be_nil
    end

  end
end
