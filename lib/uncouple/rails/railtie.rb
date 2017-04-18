class Uncouple::Railtie < Rails::Railtie

  initializer "uncouple.configure_rails_initialization" do

  end

  rake_tasks do

  end

  generators do
    require "uncouple/rails/generators/action_generator"
  end

end
