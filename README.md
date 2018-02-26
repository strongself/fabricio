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
##### App
```
  # Obtain all app
  fabricio app all

  # Obtain single app
  fabricio app get --app_id 'app_id'

  # Obtain active now count
  fabricio app active_now --organization_id 'org_id' --app_id 'app_id'

  # Obtain single issue
  fabricio app single_issue --app_id 'app_id' --issue_id 'issue_id'

  # Obtain single issue session
  fabricio app issue_session  --app_id 'app_id' --issue_id 'issue_id' --session_id 'session_id'

  # Obtain latest issue session
  fabricio app latest_session --app_id 'app_id'
```
##### Build
```
  # Obtain all builds
  fabricio build all --organization_id 'org_id' --app_id 'app_id'

  # Obtain single build
  fabricio build get --organization_id 'org_id' --app_id 'app_id' --version 'version' --build_number 'build_number'
```
##### Version
```
  # Obtain all versions
  fabricio version all --app_id 'app_id'

  # Obtain top versions               
  fabricio version top --organization_id 'org_id' --app_id 'app_id' --start_time 'timestamp' --end_time 'timestamp'
```
##### Organization
```
  # Obtain organization                  
  fabricio organization all
```
##### Other
```
  # Setup credential                                                      
  fabricio credential

  # Describe available commands or one specific command                                                       
  fabricio help [COMMAND]                                                          
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
> fabricio organization all
[{"id"=>"424423ac76fa54934e00a09b", "alias"=>"test", "name"=>"Test", "api_key"=>"19ac3e6195b1900ada120c1e0c1230a818626d55", "enrollments"=>{"answers_enhanced_feature_set_enabled_for_new_apps"=>"false", "answers_ip_address_tracking_enabled_for_new_apps"=>"true", "beta_distribution"=>"true"}, "accounts_count"=>100, "mopub_id"=>"11142", "sdk_organization"=>true, "apps_counts"=>{"ios"=>9}, "build_secret"=>"fdda1e597843e25731848bb46eec2cc893ea86847e22d5f44567ecd48ff4e32"}]
> fabricio app all
...
```
#### Default values
If your account have only one organization/app then it will be used by default and it is not necessary to set.
```
fabricio build all
```
#### Parsing
You can use [`jq`](https://stedolan.github.io/jq/) for parsing json
> fabricio version all --app_id 'app_id' | jq 'sort_by(.major)[-1].synthesized_version'
"14.0 (131)"
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
  client.app.get(app_id: 'app_id') # Returns information about specific application
  client.app.crashfree(app_id: 'app_id', start_time: '1478736000', end_time: '1481328000', build: 'all') # Returns application crashfree for a given period of time
  client.organization.all # Returns information about your organizations
  ```

3. If you want to check the exact server output for a model, you can call `json` method on it:

  `client.app.get(app_id: 'app_id').json`

  You can call a method similar to any key in this hash:

  `client.app.get(app_id: 'app_id').importance_level`

## Commands

### Organization

#### `client.organization.all`

Obtains information about your organizations.

### App

#### `client.app.all`

Obtains the list of all apps.

#### `client.app.get(app_id: 'app_id')`

Obtains a specific app.

#### `client.app.active_now(organization_id: 'organization_id', app_id: 'app_id')`

Obtains the count of active users at the current moment.

#### `client.app.daily_new(organization_id: 'organization_id', app_id: 'app_id', start_time: 'start_timestamp', end_time: 'end_timestamp')`

Obtains the count of daily new users.

#### `client.app.daily_active(app_id: 'app_id', start_time: 'start_timestamp', end_time: 'end_timestamp', build: 'build')`

Obtains the count of daily active users.

#### `client.app.total_sessions(organization_id: 'organization_id', app_id: 'app_id', start_time: 'start_timestamp', end_time: 'end_timestamp', build: 'build')`

Obtains the count of sessions.

#### `client.app.crashes(app_id: 'app_id', start_time: 'start_timestamp', end_time: 'end_timestamp', builds: 'builds')`

Obtains the count of crashes for a number of builds.

#### `client.app.crashfree(app_id: 'app_id', start_time: 'start_timestamp', end_time: 'end_timestamp', build: 'build')`

Obtains application crashfree.

> Fabric.io website uses the same calculations. However, mobile app behaves differently and shows another value.

#### `client.app.top_issues(app_id: 'app_id', start_time: 'start_timestamp', end_time: 'end_timestamp', build: 'build', count: count)`

Obtain top issues.

#### `client.app.single_issue(app_id: 'app_id', issue_id: 'issue_id', start_time: 'start_timestamp', end_time: 'end_timestamp')`

Obtain single issue.

#### `client.app.issue_session(app_id: 'app_id', issue_id: 'issue_id', session_id: 'session_id')`

Obtain issue session.

#### `client.app.add_comment(app_id: 'app_id', issue_id: 'issue_id', message: 'message')`

Add comment.

#### `client.app.oomfree(app_id: 'app_id', start_time: 'start_timestamp', end_time: 'end_timestamp', builds:'builds')`

Obtains application out-of-memory free for a number of builds.

### Build

#### `client.build.all(organization_id: 'organization_id', app_id: 'app_id')`

Obtains the list of all application builds.

#### `client.build.get(organization_id: 'organization_id', app_id: 'app_id', version: 'version', build_number: 'build_number')`

Obtains a specific build for a specific application.

### Version

#### `client.version.all(app_id: 'app_id', start_time: 'start_timestamp', end_time: 'end_timestamp')`

Obtains an array of all versions for a given application.

#### `client.version.top(organization_id: 'organization_id', app_id: 'app_id', start_time: 'start_timestamp', end_time: 'end_timestamp')`

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
