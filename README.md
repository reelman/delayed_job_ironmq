This is [IronMQ](http://www.iron.io/products/mq) backend for [delayed_job](http://github.com/collectiveidea/delayed_job)

# Getting Started

## Get credentials

Heroku users: Simply add the IronMQ add-on and you can skip the rest of this section. It will be setup
automatically when you add the IronMQ add-on.

To start using delayed_job_ironmq, you need to sign up for Iron.io and setup your credentials.

1. Go to http://iron.io/ and sign up.
2. Get an Oauth Token at http://hud.iron.io/tokens
3. Add an iron.json file or setup environment variables for authentication. See http://dev.iron.io/mq/reference/configuration/ for details.

If you want to set the Host, Post, and Protocol specifically, simply include those keys in that project's iron.json file:
```json
{
    "project_id": "PROJECT ID HERE",
    "token": "YOUR TOKEN HERE",
    "port": 443,
    "protocol": "https",
    "host":"mq-v3-aws-us-east-1.iron.io"
}
```

## Installation

Add the gems to your `Gemfile:`

```ruby
gem 'delayed_job', '~> 4.0.6'
gem 'delayed_job_ironmq', '2.0.0.pre1'
```

Optionally: Add an initializer (`config/initializers/delayed_job.rb`):

```ruby
Delayed::IronMqBackend.available_priorities = [-1,0,1,2] # Default is [0]. Please note, adding new priorities will slow down picking the next job from queue.  Also note that these priorities must include all priorities of your Delayed Jobs.
Delayed::IronMqBackend.delay = 0  # Time to wait before message will be available on the queue
Delayed::IronMqBackend.expires_in = 7.days # After this time, message will be automatically removed from the queue.
Delayed::IronMqBackend.error_queue = 'error_queue' # The failed jobs will be placed into the error queue
Delayed::IronMqBackend.default_queue = 'default' # Specify a default queue name
Delayed::IronMqBackend.queues = ['first_queue', 'second_queue'] # The queues that you want your job to run in. All queues should have been specified except default one.
```

And configure delayed job additional parameters

```ruby
Delayed::Worker.max_run_time = 1.hour
Delayed::Worker.max_attempts = 3
```

If you want to keep failed jobs, set `Delayed::Worker.destroy_failed_jobs = false`. The failed jobs will be placed into the error queue if failures exceed `Worker.max_attempts`.

## Usage

That's it. Use [delayed_job as normal](http://github.com/collectiveidea/delayed_job).

Example:

```ruby
class User
  def background_stuff
    puts "I run in the background"
  end
end
```

Then in one of your controllers:

```ruby
user = User.new
user.delay.background_stuff
```

Or declare a job using activejob like so:

```ruby
class MyJob < ActiveJob::Base
  queue_as :default
  def perform(*args)
    puts "I run in the background"
  end
end
```

Then enqueue a job:

```ruby
MyJob.perform_later record  # Enqueue a job to be performed as soon the queueing system is free.
```

```ruby
MyJob.set(wait: 1.week).perform_later(record) # Enqueue a job to be performed 1 week from now.
```

## Start worker process

    rake jobs:work

That will start pulling jobs off the queue and processing them.

# Demo Rails Application

Here's a demo rails app you can clone and try it out: https://github.com/treeder/delayed_job_ironmq_example

# Using with Heroku

To use with Heroku, just add the [IronMQ Add-on](https://addons.heroku.com/iron_mq) and
you're good to go.

# Documentation

You can find more documentation here:

* http://iron.io
* http://dev.iron.io
