require 'fabricio/networking/app_request_model_factory'
require 'fabricio/networking/network_client'
require 'fabricio/models/app'
require 'fabricio/models/point'
require 'fabricio/models/issue'
require 'fabricio/models/issue_session'

module Fabricio
  module Service
    # Service responsible for fetching different App information
    class AppService

      # Initializes a new AppService object.
      #
      # @param param_storage [Fabricio::Authorization::AbstractParamStorage]
      # @param network_client [Fabricio::Networking::NetworkClient]
      # @return [Fabricio::Service::AppService]
      def initialize(param_storage, network_client)
        @request_model_factory = Fabricio::Networking::AppRequestModelFactory.new(param_storage)
        @network_client = network_client
      end

      # Obtains the list of all apps
      #
      # @return [Array<Fabricio::Model::App>]
      def all
        request_model = @request_model_factory.all_apps_request_model
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body).map do |app_hash|
          Fabricio::Model::App.new(app_hash)
        end
      end

      # Obtains a specific app
      #
      # @return [Fabricio::Model::App]
      def get(app_id = nil)
        request_model = @request_model_factory.get_app_request_model(app_id)
        response = @network_client.perform_request(request_model)
        json = JSON.parse(response.body)
        # TODO Handle error
        Fabricio::Model::App.new(json)
      end

      # Obtains the count of active users at the current moment
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String] Application identifier
      # @return [Integer]
      def active_now(organization_id = nil, app_id = nil)
        request_model = @request_model_factory.active_now_request_model(organization_id, app_id)
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body)['cardinality']
      end

      # Obtains the count of daily new users
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @return [Array<Fabricio::Model::Point>]
      def daily_new(organization_id = nil, app_id = nil, start_time = week_ago_timestamp, end_time = today_timestamp)
        request_model = @request_model_factory.daily_new_request_model(organization_id, app_id, start_time, end_time)
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body)['series'].map do |array|
          Fabricio::Model::Point.new(array)
        end
      end

      # Obtains the count of daily active users
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @return [Array<Fabricio::Model::Point>]
      def daily_active(organization_id = nil, app_id = nil, start_time = week_ago_timestamp, end_time = today_timestamp, build)
        request_model = @request_model_factory.daily_active_request_model(organization_id, app_id, start_time, end_time, build)
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body)['series'].map do |array|
          Fabricio::Model::Point.new(array)
        end
      end

      # Obtains the count of weekly active users
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @return [Array<Fabricio::Model::Point>]
      def weekly_active(organization_id = nil, app_id = nil, start_time = week_ago_timestamp, end_time = today_timestamp, build)
        request_model = @request_model_factory.weekly_active_request_model(organization_id, app_id, start_time, end_time, build)
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body)['series'].map do |array|
          Fabricio::Model::Point.new(array)
        end
      end

      # Obtains the count of monhtly active users
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @return [Array<Fabricio::Model::Point>]
      def monthly_active(organization_id = nil, app_id = nil, start_time = week_ago_timestamp, end_time = today_timestamp, build)
        request_model = @request_model_factory.monthly_active_request_model(organization_id, app_id, start_time, end_time, build)
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body)['series'].map do |array|
          Fabricio::Model::Point.new(array)
        end
      end

      # Obtains the count of sessions
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @return [Integer]
      def total_sessions(organization_id = nil, app_id = nil, start_time = week_ago_timestamp, end_time = today_timestamp, build)
        request_model = @request_model_factory.total_sessions_request_model(organization_id, app_id, start_time, end_time, build)
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body)['sessions']
      end

      # Obtains the number of crashes
      #
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param builds [Array<String>] The versions of the app. E.g. ['4.0.1 (38)', '4.0.2 (45)']
      # @return [Integer]
      def crashes(app_id = nil, start_time = week_ago_timestamp, end_time = today_timestamp, builds)
        request_model = @request_model_factory.crash_count_request_model(app_id, start_time, end_time, builds)
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body)['data']['project']['crashlytics']['scalars']['crashes']
      end

      # Obtains application crashfree. It's calculated using a simple formula:
      # crashfree = 1 - total_crashes / total_sessions.
      # AFAIK Fabric.io website uses the same calculations. However, mobile app behaves differently and shows another value.
      #
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @return [Float]
      def crashfree(app_id = nil, start_time = week_ago_timestamp, end_time = today_timestamp, build)
        sessions = total_sessions(app_id, start_time, end_time, build)
        crashes = crashes(app_id, start_time, end_time, [build])
        1 - crashes.to_f / sessions
      end

      # Obtains top issues
      #
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @param count [Int] Number of issue
      # @return [Array<Fabricio::Model::Issue>]
      def top_issues(app_id = nil, start_time = week_ago_timestamp, end_time = today_timestamp, builds, count)
        request_model = @request_model_factory.top_issues_request_model(app_id, start_time, end_time, builds, count)
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body)['data']['project']['crashlytics']['_issues4Eg1Tv']['edges'].map do |edge|
          Fabricio::Model::Issue.new(edge['node'])
        end
      end

      # Obtains single issue
      #
      # @param issue_external_id [String] Issue external identifier
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @return [Fabricio::Model::Issue]
      def single_issue(issue_external_id, app_id = nil, start_time = week_ago_timestamp, end_time = today_timestamp)
        request_model = @request_model_factory.single_issue_request_model(app_id, issue_external_id, start_time, end_time)
        response = @network_client.perform_request(request_model)
        Fabricio::Model::Issue.new(JSON.parse(response.body)['data']['project']['crashlytics']['_issueeUsmi'])
      end

      # Obtains issue session
      #
      # @param issue_external_id [String] Issue external identifier
      # @param app_id [String] Application identifier
      # @param session_id [String] Session identifier
      # @return [Fabricio::Model::Issue]
      def issue_session(issue_external_id, session_id = 'latest', app_id = nil)
        request_model = @request_model_factory.issue_session_request_model(app_id, issue_external_id, session_id)
        response = @network_client.perform_request(request_model)
        json = JSON.parse(response.body)
        Fabricio::Model::IssueSession.new(json['data']['project']['crashlytics']['_session2RIRzK'])
      end

      # Add comment to issue
      #
      # @param app_id [String] Application identifier
      # @param issue_external_id [String] Issue external identifier
      # @param message [String] Comment message
      # @return [JSON]
      def add_comment(app_id = nil, issue_external_id, message)
        request_model = @request_model_factory.add_comment_request_model(app_id, issue_external_id, message)
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body)
      end

      # Obtains application OOM-free (Out of Memory).
      #
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param builds [Array<String>] The versions of the app. E.g. ['4.0.1 (38)', '4.0.2 (45)']
      # @return [Float]
      def oomfree(app_id = nil, start_time = week_ago_timestamp, end_time = today_timestamp, builds)
        start_date = Time.at(start_time.to_i).to_datetime
        end_date = Time.at(end_time.to_i).to_datetime
        days = (end_date - start_date).to_i + 1

        request_model = @request_model_factory.oom_count_request_model(app_id, days, builds)
        response = @network_client.perform_request(request_model)

        result = JSON.parse(response.body)
        sessions = result['data']['project']['crashlytics']['oomSessionCounts']['timeSeries'][0]['allTimeCount']
        ooms = result['data']['project']['crashlytics']['oomCounts']['timeSeries'][0]['allTimeCount']
        1 - ooms.to_f / sessions
      end

      private

      def week_ago_timestamp
        (Time.now - 60 * 60 * 24 * 7).to_i
      end

      def today_timestamp
        Time.now.to_i
      end

    end
  end
end
