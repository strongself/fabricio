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

|         | Key Features|
|---------|---------------|
|🍫 | Hides the complexity of different Fabric.io APIs behind a simple wrapper.|
|📚 | Provides data about organization, applications and builds.|
|💥 | Shows crash- and out-of-memory- free metrics.|
|⏰  | Automatically refreshes session in case of its expiration.|
|🛠 | Provides a simple way of adding your adapter for storing session data in a database of your choice.|

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

### CLI
#### Commands
```
  fabricio app get            # Obtain single app
  fabricio app all            # Obtain all app
  fabricio app active_now     # Obtain active now count
  fabricio app single_issue   # Obtain single issue
  fabricio app issue_session  # Obtain single issue session
  fabricio app latest_session # Obtain latest issue session
  fabricio build get          # Obtain single build
  fabricio build all          # Obtain all builds
  fabricio version all        # Obtain all versions
  fabricio version top        # Obtain top versions
  fabricio organization get   # Obtain organization
  fabricio credential         # Setup credential
  fabricio help [COMMAND]     # Describe available commands or one specific command
```
#### Example
```bash
> fabricio credential
Setup credential
We have to know you\'re email from fabric account
email:  test@test.com
Now we want your password. Do not be afraid, it is stored locally
password:
Successful login to TestOrganization
> fabricio organization get
{"id"=>"424423ac76fa54934e00a09b", "alias"=>"test", "name"=>"Test", "api_key"=>"19ac3e6195b1900ada120c1e0c1230a818626d55", "enrollments"=>{"answers_enhanced_feature_set_enabled_for_new_apps"=>"false", "answers_ip_address_tracking_enabled_for_new_apps"=>"true", "beta_distribution"=>"true"}, "accounts_count"=>100, "mopub_id"=>"11142", "sdk_organization"=>true, "apps_counts"=>{"ios"=>9}, "build_secret"=>"fdda1e597843e25731848bb46eec2cc893ea86847e22d5f44567ecd48ff4e32"}
> fabricio app all
...
```

### Code
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

#### `client.app.top_issues('app_id', start_timestamp, end_timestamp, 'build', count)`

Obtain top issues.

#### `client.app.single_issue('app_id', 'issue_external_id', start_timestamp, end_timestamp)`

Obtain single issue.

#### `client.app.issue_session('app_id', 'issue_external_id', 'session_id')`

Obtain issue session.

#### `client.app.add_comment('app_id', 'issue_external_id', 'message')`

Add comment.

#### `client.app.oomfree('app_id', 'start_timestamp', 'end_timestamp', 'builds')`

Obtains application out-of-memory free for a number of builds.

### Build

#### `client.build.all('app_id')`

Obtains the list of all application builds.

#### `client.build.get('app_id', 'version', 'build_number')`

Obtains a specific build for a specific application.

### Version

#### `client.version.all('app_id', 'start_timestamp', 'end_timestamp')`

Obtains an array of all versions for a given application.

#### `client.version.top('app_id', 'start_timestamp', 'end_timestamp')`

Obtains an array of top versions for a given application.

## Additional Info

Fabric.io API:

- [cURL requests](https://github.com/strongself/fabricio/blob/develop/docs/api_reference.md)
- [Swagger](https://github.com/strongself/fabricio/blob/develop/docs/swagger-api.json)

## Authors

- Egor Tolstoy
- Vadim Smal

Thanks for help in dealing with API to Irina Dyagileva and Andrey Smirnov.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
