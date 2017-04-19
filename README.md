# Uncouple

[![Build Status](https://travis-ci.org/citrus/slavery.svg?branch=master)](https://travis-ci.org/citrus/slavery)

Uncouple your business logic from rails.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'uncouple'
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
class Metric::CreateAction < Metric::NewAction

  def perform
    create_metric!
    notify! if params[:notify]
  end

  def create_metric!
    @metric = Metric.create(metric_params)
  end

  def notify!
    NewMetricMailer.notification(@metric).deliver
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
