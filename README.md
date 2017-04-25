# Fabricio

[![Gem Version](https://badge.fury.io/rb/fabricio.svg)](https://badge.fury.io/rb/fabricio)
[![](https://travis-ci.org/strongself/fabricio.svg?branch=develop)](https://travis-ci.org/strongself/fabricio)
[![Code Climate](https://codeclimate.com/github/strongself/fabricio/badges/gpa.svg)](https://codeclimate.com/github/strongself/fabricio)
[![Test Coverage](https://codeclimate.com/github/strongself/fabricio/badges/coverage.svg)](https://codeclimate.com/github/strongself/fabricio/coverage)

> pronounce as [f-ah-bree-see-oh]

A simple gem that fetches mobile application statistics from [Fabric.io](http://fabric.io) using its ~~private~~ not publicly opened [API](https://github.com/strongself/fabricio/blob/develop/docs/api_reference.md).

There is a possibility that in some point of time it may break. Feel free to [post an issue](https://github.com/strongself/fabricio/issues) and we'll fix it ASAP.

## The Story Behind

[Fabric.io](http://fabric.io) is a great tool made for mobile application developers. It provides data about standard and out-of-memory crashes, active users, audience growth and a lot more. Unfortunately the only official way to work with this data is using Fabric.io website. That means - no automation and no integrations with other services. 

We decided to fix this issue.

         | Key Features
---------|---------------
🍫 | Hides the complexity of different Fabric.io APIs behind a simple wrapper.
📚 | Provides data about organization, applications and builds.
💥 | Shows crash- and out-of-memory- free metrics.
⏰  | Automatically refreshes session in case of its expiration.
🛠 | Provides a simple way of adding your adapter for storing session data in a database of your choice.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fabricio'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fabricio
    
## Quick Start

1. Create a `Fabricio::Client` object and configure it on initialization.

  ```ruby
  require 'Fabricio'
  
  client = Fabricio::Client.new do |config|
      config.username = 'your_email'
      config.password = 'your_password'
  end
  ```
  
2. Use this client to query any data you want.

  ```ruby
  client.app.all # Returns all applications on your account
  client.app.get('app_id') # Returns information about specific application
  client.app.crashfree('app_id', '1478736000', '1481328000' 'all') # Returns application crashfree for a given period of time
  client.organization.get # Returns information about your organization
  ```
  
3. If you want to check the exact server output for a model, you can call `json` method on it:

  `client.app.get('app_id').json`
  
  You can call a method similar to any key in this hash:
  
  `client.app.get('app_id').importance_level`
  
## Commands

### Organization

#### `client.organization.get`

Obtains information about your organization.

### App

#### `client.app.all`

Obtains the list of all apps.

#### `client.app.get('app_id')`

Obtains a specific app.

#### `client.app.active_now('app_id')`

Obtains the count of active users at the current moment.

#### `client.app.daily_new('app_id', 'start_timestamp', 'end_timestamp')`

Obtains the count of daily new users.

#### `client.app.daily_active('app_id', 'start_timestamp', 'end_timestamp', 'build')`

Obtains the count of daily active users.

#### `client.app.total_sessions('app_id', 'start_timestamp', 'end_timestamp', 'build')`

Obtains the count of sessions.

#### `client.app.crashes('app_id', 'start_timestamp', 'end_timestamp', 'builds')`

Obtains the count of crashes for a number of builds.

#### `client.app.crashfree('app_id', 'start_timestamp', 'end_timestamp', 'build')`

Obtains application crashfree.

> Fabric.io website uses the same calculations. However, mobile app behaves differently and shows another value.

#### `client.app.oomfree('app_id', 'start_timestamp', 'end_timestamp', 'builds')`

Obtains application out-of-memory free for a number of builds.

### Build

#### `client.build.all('app_id')`

Obtains the list of all application builds.

#### `client.build.get('app_id', 'version', 'build_number')`

Obtains a specific build for a specific application.

#### `client.build.top_versions('app_id', 'start_timestamp', 'end_timestamp')`

Obtains an array of top versions for a given application.

## Additional Info

Fabric.io API:

- [cURL requests](https://github.com/strongself/fabricio/blob/develop/docs/api_reference.md)
- [Swagger](https://github.com/strongself/fabricio/blob/develop/docs/swagger-api.json)

## Authors

- Egor Tolstoy

Thanks for help in dealing with API to Vadim Smal, Irina Dyagileva and Andrey Smirnov.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

