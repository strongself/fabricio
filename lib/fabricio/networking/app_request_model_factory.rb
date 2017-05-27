require 'json'
require 'fabricio/networking/request_model'

module Fabricio
  module Networking
    # This factory creates request models for fetching data for App model object
    class AppRequestModelFactory

      # Server constants
      FABRIC_API_URL = 'https://fabric.io'
      FABRIC_GRAPHQL_API_URL = 'https://api-dash.fabric.io/graphql'
      FABRIC_API_PATH = '/api/v2'
      FABRIC_APPS_ENDPOINT = '/apps'
      FABRIC_ORGANIZATIONS_ENDPOINT = '/organizations'

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
      def get_app_request_model(app_id)
        path = "#{FABRIC_API_PATH}#{app_endpoint(app_id)}"
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = path
        end
        model
      end

      # Returns a request model for obtaining the count of active users at the current moment
      #
      # @param session [Fabricio::Authorization::Session]
      # @param app_id [String]
      # @return [Fabricio::Networking::RequestModel]
      def active_now_request_model(session, app_id)
        path = growth_analytics_endpoint(session, app_id, 'active_now')
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = path
        end
        model
      end

      # Returns a request model for obtaining the count of daily new users
      #
      # @param session [Fabricio::Authorization::Session]
      # @param app_id [String]
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @return [Fabricio::Networking::RequestModel]
      def daily_new_request_model(session, app_id, start_time, end_time)
        path = growth_analytics_endpoint(session, app_id, 'daily_new')
        params = time_range_params(start_time, end_time)
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
      # @param session [Fabricio::Authorization::Session]
      # @param app_id [String]
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @return [Fabricio::Networking::RequestModel]
      def daily_active_request_model(session, app_id, start_time, end_time, build)
        path = growth_analytics_endpoint(session, app_id, 'daily_active')
        params = time_range_params(start_time, end_time)
        params['build'] = build
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = path
          config.params = params
        end
        model
      end

      # Returns a request model for obtaining the count of sessions
      #
      # @param session [Fabricio::Authorization::Session]
      # @param app_id [String]
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @return [Fabricio::Networking::RequestModel]
      def total_sessions_request_model(session, app_id, start_time, end_time, build)
        path = growth_analytics_endpoint(session, app_id, 'total_sessions_scalar')
        params = {
            'start' => start_time,
            'end' => end_time,
            'build' => build
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
      # @return [Fabricio::Networking::RequestModel]
      def crash_count_request_model(app_id, start_time, end_time, builds)
        headers = {
            'Content-Type' => 'application/json'
        }
        builds_string = builds.map { |build|
          "\"#{build}\""
        }.join(',')
        body = {
          'query' => "query AppScalars($app_id:String!,$type:IssueType!) {project(externalId:$app_id) {crashlytics {scalars:scalars(synthesizedBuildVersions:[#{builds_string}],type:$type,start:#{start_time},end:#{end_time}) {crashes}}}}",
          'variables' => {
              'app_id' => app_id,
              'type' => 'crash'
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
      # @return [Fabricio::Networking::RequestModel]
      def top_issues_request_model(app_id, start_time, end_time, builds, count)
        headers = {
            'Content-Type' => 'application/json'
        }
        builds_string = builds.map { |build|
          "\"#{build}\""
        }.join(',')

        body = {
          'query' => "query TopIssues($externalId_0:String!,$type_1:IssueType!,$start_2:UnixTimestamp!,$end_3:UnixTimestamp!,$filters_4:IssueFiltersType!,$state_5:IssueState!) {project(externalId:$externalId_0) {crashlytics {_appDetails1JwAD1:appDetails(synthesizedBuildVersions:[#{builds_string}],type:$type_1,start:$start_2,end:$end_3,filters:$filters_4) {topCrashInsightsMatchers {groupKey}},_issues4Eg1Tv:issues(synthesizedBuildVersions:[#{builds_string}],eventType:$type_1,start:$start_2,end:$end_3,state:$state_5,first:#{count},filters:$filters_4) {edges {node {externalId,displayId,createdAt,resolvedAt,title,subtitle,state,type,impactLevel,isObfuscated,occurrenceCount,impactedDevices,latestSessionId,notesCount,earliestBuildVersion {buildVersion {name}},latestBuildVersion {buildVersion {name}},id},cursor},pageInfo {hasNextPage,hasPreviousPage}}},id}}",
          'variables' => {
              'externalId_0' => app_id,
              'type_1' => 'all',
              'start_2' => start_time,
              'end_3' => end_time,
              'filters_4' => { 'osMinorVersion' => [], 'deviceModel' => [] },
              'state_5' => 'open'
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
      # @param issue_external_id [String] Issue external identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @return [Fabricio::Networking::RequestModel]
      def single_issue_request_model(app_id, issue_external_id, start_time, end_time)
        headers = {
            'Content-Type' => 'application/json'
        }

        body = {
          'query' => "query SingleIssue($externalId_0:String!,$start_1:UnixTimestamp!,$end_2:UnixTimestamp!,$granularity_3:TimeseriesGranularity!,$filters_4:IssueFiltersType!) {project(externalId:$externalId_0) {crashlytics {_issueeUsmi:issue(externalId:\"#{issue_external_id}\") {externalId,createdAt,displayId,title,subtitle,type,state,isObfuscated,supportsCrossVersion,_occurrenceCount2I980d:occurrenceCount(start:$start_1,end:$end_2),_impactedDevices2oATOx:impactedDevices(start:$start_1,end:$end_2),shareLink,latestSessionId,lockedAt,resolvedAt,exportUserIdsUrl,buildVersionBreakdown {occurrenceCount,buildVersion {externalId,createdAt,name,synthesizedBuildVersion}},earliestBuildVersion {buildVersion {externalId,createdAt,name,synthesizedBuildVersion}},latestBuildVersion {buildVersion {externalId,createdAt,name,synthesizedBuildVersion}},notes {externalId,createdAt,body,account {id,name,email}},_timeseries1niuOE:timeseries(granularity:$granularity_3,start:$start_1,end:$end_2) {eventsCount,groupByDimension,dimensionKey},_scalars1YYKRB:scalars(start:$start_1,end:$end_2,filters:$filters_4) {deviceMetrics {eventsCount,jailbrokenRatio,inFocusRatio,proximityOnRatio,freeRamMean,freeDiskMean},topOs {value,label,groupKey,eventsCount},topDevices {value,label,groupKey,eventsCount},topCrashInsightsMatchers {value,label,groupKey,eventsCount,issuesCount,impactedDevicesCount}},id}},id}}",
          'variables' => {
              'externalId_0' => app_id,
              'start_1' => start_time,
              'end_2' => end_time,
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

      # Returns a request model for obtaining the count of ooms
      #
      # @param app_id [String]
      # @param days [Integer] Count of days for obtaining oomfree data
      # @param builds [Array] Multiple build versions. E.g. ['4.0.1 (38)']
      # @return [Fabricio::Networking::RequestModel]
      def oom_count_request_model(app_id, days, builds)
        headers = {
            'Content-Type' => 'application/json'
        }
        body = {
            'query' => 'query oomCountForDaysForBuild($app_id: String!, $builds: [String!]!, $days: Int!) { project(externalId: $app_id) { crashlytics{ oomCounts(builds: $builds, days: $days){ timeSeries{ allTimeCount } } oomSessionCounts(builds: $builds, days: $days){ timeSeries{ allTimeCount } } } } }',
            'variables' => {
                'app_id' => app_id,
                'days' => days,
                'builds' => builds
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

      private

      # Returns an API path to some growth analytic endpoint
      #
      # @param session [Fabricio::Authorization::Session]
      # @param app_id [String]
      # @param name [String]
      # @return [String]
      def growth_analytics_endpoint(session, app_id, name)
        "#{FABRIC_API_PATH}#{org_app_endpoint(session, app_id)}/growth_analytics/#{name}.json"
      end

      # Returns an API path to organization endpoint
      #
      # @param session [Fabricio::Authorization::Session]
      # @param app_id [String]
      # @return [String]
      def org_app_endpoint(session, app_id)
        "#{org_endpoint(session)}/#{app_endpoint(app_id)}"
      end

      # Returns an API path to app endpoint
      #
      # @param app_id [String]
      # @return [String]
      def app_endpoint(app_id)
        "/#{FABRIC_APPS_ENDPOINT}/#{app_id}"
      end

      # Returns an API path to app endpoint
      #
      # @param session [Fabricio::Authorization::Session]
      # @return [String]
      def org_endpoint(session)
        "/#{FABRIC_ORGANIZATIONS_ENDPOINT}/#{session.organization_id}"
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
