require "spec_helper"

RSpec.describe Uncouple::Action::Authorization do

  let(:action) do
    Uncouple::Action.new({})
  end

  describe "#perform_with_authorization" do

    it "calls to authorize! before calling perform" do
      expect(action).to receive(:authorize!)
      action.perform_with_authorization
    end

    it "calls to perform if authorize! returns true" do
      expect(action).to receive(:perform)
      action.perform_with_authorization
    end

  end

  describe "#authorize!" do

    it "returns true until overwritten" do
      expect(action.authorize!).to be(true)
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
