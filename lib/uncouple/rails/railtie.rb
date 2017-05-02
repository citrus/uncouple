class Uncouple::Railtie < Rails::Railtie

  initializer "uncouple.configure_rails_initialization" do
    require "uncouple/action/instrumentation"
    Uncouple::Action.send(:extend, Uncouple::Action::Instrumentation)
  end

  generators do
    require "uncouple/rails/generators/action_generator"
  end

end
