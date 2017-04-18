module Uncouple
  module Generators
    class Action < Rails::Generators::Base

      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      attr_accessor :name

      desc "Generates an action."

      def action_generator
        self.name = args.first.to_s.downcase
        raise "Invalid Action Name" if name.blank?
        template "app/actions/action.rb", "app/actions/#{name}_action.rb"
        if defined?(RSpec)
          template "spec/actions/action_spec.rb", "spec/actions/#{feature}/#{name}_action_spec.rb"
        end
      end

    end
  end
end
