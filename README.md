# Uncouple

[![Gem Version](https://badge.fury.io/rb/uncouple.svg)](https://badge.fury.io/rb/uncouple)
[![Build Status](https://travis-ci.org/citrus/uncouple.svg?branch=master)](https://travis-ci.org/citrus/uncouple)

Uncouple your business logic from Rails or whatever other framework you may be using.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'uncouple'
```

If you're on rails:

```ruby
gem 'uncouple', require: 'uncouple/rails'
```


And then execute:

    $ bundle

Or install it yourself as:

    $ gem install uncouple


## Usage

Create actions in `app/actions/:model_name/:action_name`. If you're on rails, you can use the included generator:

```sh
rails generate uncouple:action metric/create
```

Use actions to encapsulate your business logic.

```rb
# app/actions/metric/create_action.rb
class Metric::CreateAction < Uncouple::Action

  attr_reader :metric

  def perform
    create_metric!
    notify! if params[:notify]
  end

  def create_metric!
    @metric = Metric.create(metric_params)
  end

  def notify!
    NewMetricMailer.notification(metric).deliver
  end

  def success?
    metric.try(:persisted?)
  end

private

  def metric_params
    params.require(:metric).permit(:name, :value)
  end

end
```


##### Then invoke these actions wherever needed...

In the console:

```ruby
action = Metric::CreateAction.new(metric: { name: "RPM", value: 5 })
action.perform
action.success?
```

Or in the controller using the [Uncouple::ActionPerformer](https://github.com/citrus/uncouple/blob/master/lib/uncouple/action_performer.rb)

```rb
# app/controllers/metrics_controller.rb
class MetricsController < ApplicationController

  include Uncouple::ActionPerformer

  def create
    perform Metric::CreateAction do
      return redirect_to(metrics_path)
    end
    render :new
  end

end
```

If available, `Uncouple::ActionPerformer` injects your controller's `current_user` into the action and calls `perform_with_authorization` under the hood. Overwrite `authorize!` in your action to ensure the user has permission to call the action.

Actions also include a `current_user` helper method.

For example, you can use pundit like this:

```rb
class Metric::CreateAction < Uncouple::Action

  def authorize!
    Pundit.authorize(current_user, Metric, :create?)
  end

  # ...

end
```

## Instrumentation through ActiveSupport::Notifications

Version 0.2.0 adds support for instrumentation on `perform` and `authorize!` using ActiveSupport::Notifications. Subscribe to notifications using an initializer, and do whatever you like with the data.

```rb
# config/initializers/notifications.rb
ActiveSupport::Notifications.subscribe /.*(Action)#(perform|authorize!)/ do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  Rails.logger.info "#{event.name} completed in #{event.duration}ms"
end

#=> Metric::IndexAction#perform completed in 8.253ms
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Testing

Tests can be run with rspec:

```sh
bundle exec rspec
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/citrus/uncouple. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
