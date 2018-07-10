require 'fabricio/networking/request_model_factory'
require 'fabricio/networking/request_model'
require 'json'

module Fabricio
  module Networking
    # This factory creates request models for fetching data for App model object
    class AppRequestModelFactory < RequestModelFactory

      # Returns a request model for obtaining the list of all apps
      #
      # @return [Fabricio::Networking::RequestModel]
      def all_apps_request_model
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = FABRIC_API_PATH + FABRIC_APPS_ENDPOINT
        end
        model
      end

      # Returns a request model for obtaining a specific app
      #
      # @param app_id [String]
      # @return [Fabricio::Networking::RequestModel]
      def get_app_request_model(options = {})
        options = { :app_id => stored_app_id }.merge(options)
        validate_options(options)
        path = "#{FABRIC_API_PATH}#{app_endpoint(options[:app_id])}"
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = path
        end
        model
      end

      # Returns a request model for obtaining the count of active users at the current moment
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String]
      # @return [Fabricio::Networking::RequestModel]
      def active_now_request_model(options = {})
        options = {
          :organization_id => stored_organization_id,
          :app_id => stored_app_id
        }.merge(options)
        validate_options(options)
        path = growth_analytics_endpoint(options[:organization_id], options[:app_id], 'active_now')
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = path
        end
        model
      end

      # Returns a request model for obtaining the count of daily new users
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String]
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @return [Fabricio::Networking::RequestModel]
      def daily_new_request_model(options = {})
        options = {
          :organization_id => stored_organization_id,
          :app_id => stored_app_id,
          :start_time => week_ago_timestamp,
          :end_time => today_timestamp
        }.merge(options)
        validate_options(options)
        path = growth_analytics_endpoint(options[:organization_id], options[:app_id], 'daily_new')
        params = time_range_params(options[:start_time], options[:end_time])
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = path
          config.params = params
        end
        model
      end

      # Returns a request model for obtaining the count of daily active users
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String]
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @return [Fabricio::Networking::RequestModel]
      def daily_active_request_model(options = {})
        options = { :active_name => 'daily_active' }.merge(options)
        active_request_model(options)
      end

      # Returns a request model for obtaining the count of weekly active users
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String]
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @return [Fabricio::Networking::RequestModel]
      def weekly_active_request_model(options = {})
        options = { :active_name => 'weekly_active' }.merge(options)
        active_request_model(options)
      end

      # Returns a request model for obtaining the count of monhtly active users
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String]
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @return [Fabricio::Networking::RequestModel]
      def monthly_active_request_model(options = {})
        options = { :active_name => 'monthly_active' }.merge(options)
        active_request_model(options)
      end

      # Returns a request model for obtaining the count of sessions
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String]
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @return [Fabricio::Networking::RequestModel]
      def total_sessions_request_model(options = {})
        options = {
          :organization_id => stored_organization_id,
          :app_id => stored_app_id,
          :start_time => week_ago_timestamp,
          :end_time => today_timestamp,
          :build => 'all'
        }.merge(options)
        validate_options(options)
        path = growth_analytics_endpoint(options[:organization_id], options[:app_id], 'total_sessions_scalar')
        params = {
            'start' => options[:start_time],
            'end' => options[:end_time],
            'build' => options[:build]
        }
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = path
          config.params = params
        end
        model
      end

      # Returns a request model for obtaining the count of app crashes
      #
      # @param app_id [String]
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param builds [Array] Multiple build versions. E.g. ['4.0.1 (38)']
      # @param type [String] Issue type: all, crash or error
      # @return [Fabricio::Networking::RequestModel]
      def crash_count_request_model(options = {})
        options = {
          :app_id => stored_app_id,
          :start_time => week_ago_timestamp,
          :end_time => today_timestamp,
          :builds => ['all'],
          :type => 'crash'
        }.merge(options)
        validate_options(options)
        headers = {
            'Content-Type' => 'application/json'
        }
        builds_string = options[:builds].map { |build|
          "\"#{build}\""
        }.join(',')
        body = {
          'query' => "query AppScalars($app_id:String!,$type:IssueType!) {project(externalId:$app_id) {crashlytics {scalars:scalars(synthesizedBuildVersions:[#{builds_string}],type:$type,start:#{options[:start_time]},end:#{options[:end_time]}) {crashes}}}}",
          'variables' => {
              'app_id' => options[:app_id],
              'type' => options[:type]
          }
        }.to_json
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :POST
          config.base_url = FABRIC_GRAPHQL_API_URL
          config.headers = headers
          config.body = body
        end
        model
      end

      # Returns a request model for obtaining top issues
      #
      # @param app_id [String]
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param builds [Array] Multiple build versions. E.g. ['4.0.1 (38)']
      # @param count [Int] Number of issue
      # @param type [String] Issue type: all, crash or error
      # @param state [String] Issue state: all, open or closed
      # @return [Fabricio::Networking::RequestModel]
      def top_issues_request_model(options = {})
        options = {
          :app_id => stored_app_id,
          :start_time => week_ago_timestamp,
          :end_time => today_timestamp,
          :builds => ['all'],
          :count => 100,
          :type => 'crash',
          :state => 'open'
        }.merge(options)
        validate_options(options)
        headers = {
            'Content-Type' => 'application/json'
        }
        builds_string = options[:builds].map { |build| "\"#{build}\"" }.join(',')
        body = {
          'query' => "query TopIssues($externalId_0:String!,$type_1:IssueType!,$start_2:UnixTimestamp!,$end_3:UnixTimestamp!,$filters_4:IssueFiltersType!,$state_5:IssueState!) {project(externalId:$externalId_0) {crashlytics {_appDetails1JwAD1:appDetails(synthesizedBuildVersions:[#{builds_string}],type:$type_1,start:$start_2,end:$end_3,filters:$filters_4) {topCrashInsightsMatchers {groupKey}},_issues4Eg1Tv:issues(synthesizedBuildVersions:[#{builds_string}],eventType:$type_1,start:$start_2,end:$end_3,state:$state_5,first:#{options[:count]},filters:$filters_4) {edges {node {externalId,displayId,createdAt,resolvedAt,title,subtitle,state,type,impactLevel,isObfuscated,occurrenceCount,impactedDevices,latestSessionId,notesCount,earliestBuildVersion {buildVersion {name}},latestBuildVersion {buildVersion {name}},id},cursor},pageInfo {hasNextPage,hasPreviousPage}}},id}}",
          'variables' => {
              'externalId_0' => options[:app_id],
              'type_1' => options[:type],
              'start_2' => options[:start_time],
              'end_3' => options[:end_time],
              'filters_4' => { 'osMinorVersion' => [], 'deviceModel' => [] },
              'state_5' => options[:state]
          }
        }.to_json
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :POST
          config.base_url = FABRIC_GRAPHQL_API_URL
          config.api_path = '?relayDebugName=TopIssues'
          config.headers = headers
          config.body = body
        end
        model
      end

      # Returns a request model for obtaining single issue
      #
      # @param app_id [String]
      # @param issue_id [String] Issue identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @return [Fabricio::Networking::RequestModel]
      def single_issue_request_model(options = {})
        options = {
            :app_id => stored_app_id,
            :issue_id => nil,
            :start_time => week_ago_timestamp,
            :end_time => today_timestamp
        }.merge(options)
        validate_options(options)
        headers = {
            'Content-Type' => 'application/json'
        }
        body = {
          'query' => "query SingleIssue($externalId_0:String!,$start_1:UnixTimestamp!,$end_2:UnixTimestamp!,$granularity_3:TimeseriesGranularity!,$filters_4:IssueFiltersType!) {project(externalId:$externalId_0) {crashlytics {_issueeUsmi:issue(externalId:\"#{options[:issue_id]}\") {externalId,createdAt,displayId,title,subtitle,type,state,isObfuscated,supportsCrossVersion,_occurrenceCount2I980d:occurrenceCount(start:$start_1,end:$end_2),_impactedDevices2oATOx:impactedDevices(start:$start_1,end:$end_2),shareLink,latestSessionId,lockedAt,resolvedAt,exportUserIdsUrl,buildVersionBreakdown {occurrenceCount,buildVersion {externalId,createdAt,name,synthesizedBuildVersion}},earliestBuildVersion {buildVersion {externalId,createdAt,name,synthesizedBuildVersion}},latestBuildVersion {buildVersion {externalId,createdAt,name,synthesizedBuildVersion}},notes {externalId,createdAt,body,account {id,name,email}},_timeseries1niuOE:timeseries(granularity:$granularity_3,start:$start_1,end:$end_2) {eventsCount,groupByDimension,dimensionKey},_scalars1YYKRB:scalars(start:$start_1,end:$end_2,filters:$filters_4) {deviceMetrics {eventsCount,jailbrokenRatio,inFocusRatio,proximityOnRatio,freeRamMean,freeDiskMean},topOs {value,label,groupKey,eventsCount},topDevices {value,label,groupKey,eventsCount},topCrashInsightsMatchers {value,label,groupKey,eventsCount,issuesCount,impactedDevicesCount}},id}},id}}",
          'variables' => {
              'externalId_0' => options[:app_id],
              'start_1' => options[:start_time],
              'end_2' => options[:end_time],
              'granularity_3' => 'day',
              'filters_4' => {}
          }
        }.to_json
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :POST
          config.base_url = FABRIC_GRAPHQL_API_URL
          config.api_path = '?relayDebugName=SingleIssue'
          config.headers = headers
          config.body = body
        end
        model
      end

      # Returns a request model for obtaining issue session
      #
      # @param app_id [String]
      # @param issue_id [String] Issue identifier
      # @param session_id [String] Session identifier
      # @return [Fabricio::Networking::RequestModel]
      def issue_session_request_model(options = {})
        options = {
          :app_id => stored_app_id,
          :issue_id => nil,
          :session_id => 'latest'
        }.merge(options)
        validate_options(options)
        headers = {
            'Content-Type' => 'application/json'
        }
        body = {
          'query' => "query SingleSession($externalId_0:String!) {project(externalId:$externalId_0) {crashlytics {_session2RIRzK:session(externalId:\"#{options[:session_id]}\",issueId:\"#{options[:issue_id]}\") {externalId,createdAt,buildVersionId,prevSessionId,nextSessionId,sdk {display},os {platform,build,display,name,modified},orientation {device,ui},customLogs {time,message},customKeys {key,value},memory {free,used},storage {free,used},device {architecture,manufacturer,model,name,proximityOn,betaDeviceToken},user {externalId,name,email},stacktraces {exceptions {caption {title,subtitle},interesting,fatal,state,threadName,queueName,crash {name,code,address},exception {message,type,nested},frames {file,offset,line,address,symbol,rawSymbol,owner,library,blamed,native}},errors {caption {title,subtitle},interesting,fatal,state,threadName,queueName,crash {name,code,address},exception {message,type,nested},frames {file,offset,line,address,symbol,rawSymbol,owner,library,blamed,native}},threads {caption {title,subtitle},interesting,fatal,state,threadName,queueName,crash {name,code,address},exception {message,type,nested},frames {file,offset,line,address,symbol,rawSymbol,owner,library,blamed,native}}}}},id}}",
          'variables' => {
              'externalId_0' => options[:app_id]
          }
        }.to_json
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :POST
          config.base_url = FABRIC_GRAPHQL_API_URL
          config.api_path = '?relayDebugName=SingleSession'
          config.headers = headers
          config.body = body
        end
        model
      end

      # Returns a request model for add comment to issue
      #
      # @param app_id [String]
      # @param issue_id [String] Issue identifier
      # @param message [String] Comment message
      # @return [Fabricio::Networking::RequestModel]
      def add_comment_request_model(options = {})
        options = {
          :app_id => stored_app_id,
          :issue_id => nil,
          :message => ''
        }.merge(options)
        validate_options(options)
        headers = {
            'Content-Type' => 'application/json'
        }
        body = {
          'body' => options[:message],

        }.to_json
        path = add_comment_endpoint(options[:app_id], options[:issue_id])
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :POST
          config.base_url = FABRIC_API_URL
          config.api_path = path
          config.headers = headers
          config.body = body
        end
        model
      end

      # Returns a request model for obtaining the count of ooms
      #
      # @param app_id [String]
      # @param days [Integer] Count of days for obtaining oomfree data
      # @param builds [Array] Multiple build versions. E.g. ['4.0.1 (38)']
      # @return [Fabricio::Networking::RequestModel]
      def oom_count_request_model(options = {})
        options = {
          :app_id => stored_app_id,
          :days => 7,
          :builds => ['all']
        }.merge(options)
        validate_options(options)
        headers = {
            'Content-Type' => 'application/json'
        }
        body = {
            'query' => 'query oomCountForDaysForBuild($app_id: String!, $builds: [String!]!, $days: Int!) { project(externalId: $app_id) { crashlytics{ oomCounts(builds: $builds, days: $days){ timeSeries{ allTimeCount } } oomSessionCounts(builds: $builds, days: $days){ timeSeries{ allTimeCount } } } } }',
            'variables' => {
                'app_id' => options[:app_id],
                'days' => options[:days],
                'builds' => options[:builds]
            }
        }.to_json
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :POST
          config.base_url = FABRIC_GRAPHQL_API_URL
          config.headers = headers
          config.body = body
        end
        model
      end

      # Returns a request model for obtaining the list of all custom event types
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String]
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @return [Fabricio::Networking::RequestModel]
      def all_custom_event_request_model(options = {})
        options = {
          :organization_id => stored_organization_id,
          :app_id => stored_app_id,
          :start_time => week_ago_timestamp,
          :end_time => today_timestamp,
          :build => 'all'
        }.merge(options)
        validate_options(options)
        path = growth_analytics_endpoint(options[:organization_id], options[:app_id], 'event_types_with_data')
        params = time_range_params(options[:start_time], options[:end_time])
        params['build'] = options[:build]
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = path
          config.params = params
        end
        model
      end

      # Returns a request model for obtaining the total count of specified custom event type
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String]
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @param event_type [String] The custom event name. E.g. 'Custom Event Name'
      # @return [Fabricio::Networking::RequestModel]
      def custom_event_total_request_model(options = {})
        options = { :name => 'pe_total_events' }.merge(options)
        custom_event_request_model(options)
      end

      # Returns a request model for obtaining the unique devices count of specified custom event type
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String]
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @param event_type [String] The custom event name. E.g. 'Custom Event Name'
      # @return [Fabricio::Networking::RequestModel]
      def custom_event_unique_devices_request_model(options = {})
        options = { :name => 'ce_unique_devices' }.merge(options)
        custom_event_request_model(options)
      end

      # Returns a request model for obtaining the list of all attributes of specified custom event type
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String]
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param event_type [String] The custom event name. E.g. 'Custom Event Name'
      # @return [Fabricio::Networking::RequestModel]
      def all_custom_event_attribute_request_model(options = {})
        options = {
          :organization_id => stored_organization_id,
          :app_id => stored_app_id,
          :start_time => week_ago_timestamp,
          :end_time => today_timestamp,
          :event_type => nil
        }.merge(options)
        validate_options(options)
        path = growth_analytics_endpoint(options[:organization_id], options[:app_id], 'ce_attribute_metadata')
        params = time_range_params(options[:start_time], options[:end_time])
        params['event_type'] = options[:event_type]
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = path
          config.params = params
        end
        model
      end

      # Returns a request model for obtaining the attribute counts of specified custom event type
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String]
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @param event_type [String] The custom event name. E.g. 'Custom Event Name'
      # @param event_attribute [String] The custom event attribute. E.g. 'Custom Attribute'
      # @param selected_time [String] Timestamp of the selected date
      # @return [Fabricio::Networking::RequestModel]
      def custom_event_attribute_request_model(options = {})
        options = {
          :organization_id => stored_organization_id,
          :app_id => stored_app_id,
          :start_time => week_ago_timestamp,
          :end_time => today_timestamp,
          :build => 'all',
          :event_type => nil,
          :event_attribute => nil,
          :selected_time => nil,
          :limit => 10
        }.merge(options)
        validate_options(options)
        path = growth_analytics_endpoint(options[:organization_id], options[:app_id], 'ce_category_attribute_data')
        params = {
          'timeseries_start' => options[:start_time],
          'timeseries_end' => options[:end_time],
          'build' => options[:build],
          'event_type' => options[:event_type],
          'attribute' => options[:event_attribute],
          'limit' => options[:limit],
          'selected_day' => options[:selected_time]
        }
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = path
          config.params = params
        end
        model
      end

      private

      # Returns a request model for obtaining the count of active users
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String]
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @param name [String] Active type: monthly_active, weekly_active, daily_active
      # @return [Fabricio::Networking::RequestModel]
      def active_request_model(options = {})
        options = {
          :organization_id => stored_organization_id,
          :app_id => stored_app_id,
          :start_time => week_ago_timestamp,
          :end_time => today_timestamp,
          :build => 'all',
          :active_name => nil
        }.merge(options)
        validate_options(options)
        path = growth_analytics_endpoint(options[:organization_id], options[:app_id], options[:active_name])
        params = time_range_params(options[:start_time], options[:end_time])
        params['build'] = options[:build]
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = path
          config.params = params
        end
        model
      end

      # Returns a request model for obtaining the custom event metrics
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String]
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @param event_type [String] The custom event name. E.g. 'Custom Event Name'
      # @param name [String] Custom event type: total_events, unique_devices
      # @return [Fabricio::Networking::RequestModel]
      def custom_event_request_model(options = {})
        options = {
          :organization_id => stored_organization_id,
          :app_id => stored_app_id,
          :start_time => week_ago_timestamp,
          :end_time => today_timestamp,
          :build => 'all',
          :event_type => nil,
          :name => nil
        }.merge(options)
        validate_options(options)
        path = growth_analytics_endpoint(options[:organization_id], options[:app_id], options[:name])
        params = time_range_params(options[:start_time], options[:end_time])
        params['build'] = options[:build]
        params['event_type'] = options[:event_type]
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = path
          config.params = params
        end
        model
      end

      # Returns an API path to some issue session
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String]
      # @param issue_id [String]
      # @param session_id [String]
      # @return [String]
      def add_comment_endpoint(app_id, issue_id)
        "#{FABRIC_API_3_PATH}#{FABRIC_PROJECTS_ENDPOINT}/#{app_id}/issues/#{issue_id}/notes"
      end

      # Returns an API path to some growth analytic endpoint
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String]
      # @param name [String]
      # @return [String]
      def growth_analytics_endpoint(session, app_id, name)
        "#{FABRIC_API_PATH}#{org_app_endpoint(session, app_id)}/growth_analytics/#{name}.json"
      end

      # Returns an API path to app endpoint
      #
      # @param start_time [String]
      # @param end_time [String]
      # @return [Hash]
      def time_range_params(start_time, end_time)
        {
            'start' => start_time,
            'end' => end_time
        }
      end

    end
  end
end
