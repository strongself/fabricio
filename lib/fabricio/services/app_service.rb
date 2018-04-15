require 'fabricio/networking/app_request_model_factory'
require 'fabricio/networking/network_client'
require 'fabricio/models/app'
require 'fabricio/models/point'
require 'fabricio/models/issue'
require 'fabricio/models/issue_session'
require 'fabricio/models/custom_event_attribute_name'
require 'fabricio/models/custom_event_attribute_value'

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
      # @param app_id [String] Application identifier
      # @return [Fabricio::Model::App]
      def get(options = {})
        request_model = @request_model_factory.get_app_request_model(options)
        response = @network_client.perform_request(request_model)
        json = JSON.parse(response.body)
        Fabricio::Model::App.new(json)
      end

      # Obtains the count of active users at the current moment
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String] Application identifier
      # @return [Integer]
      def active_now(options = {})
        request_model = @request_model_factory.active_now_request_model(options)
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
      def daily_new(options = {})
        request_model = @request_model_factory.daily_new_request_model(options)
        response = @network_client.perform_request(request_model)
        parse_point_response(response)
      end

      # Obtains the count of daily active users
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @return [Array<Fabricio::Model::Point>]
      def daily_active(options = {})
        request_model = @request_model_factory.daily_active_request_model(options)
        response = @network_client.perform_request(request_model)
        parse_point_response(response)
      end

      # Obtains the count of weekly active users
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @return [Array<Fabricio::Model::Point>]
      def weekly_active(options = {})
        request_model = @request_model_factory.weekly_active_request_model(options)
        response = @network_client.perform_request(request_model)
        parse_point_response(response)
      end

      # Obtains the count of monhtly active users
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @return [Array<Fabricio::Model::Point>]
      def monthly_active(options = {})
        request_model = @request_model_factory.monthly_active_request_model(options)
        response = @network_client.perform_request(request_model)
        parse_point_response(response)
      end

      # Obtains the count of sessions
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @return [Integer]
      def total_sessions(options = {})
        request_model = @request_model_factory.total_sessions_request_model(options)
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body)['sessions']
      end

      # Obtains the number of crashes
      #
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param builds [Array<String>] The versions of the app. E.g. ['4.0.1 (38)', '4.0.2 (45)']
      # @param type [String] Issue type: all, crash or error
      # @return [Integer]
      def crashes(options = {})
        request_model = @request_model_factory.crash_count_request_model(options)
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
      # @param type [String] Issue type: all, crash or error
      # @return [Float]
      def crashfree(options = {})
        sessions = total_sessions(options)
        unless options[:build].nil?
          options[:builds] = [options[:build]]
        end
        crashes = crashes(options)
        1 - crashes.to_f / sessions
      end

      # Obtains top issues
      #
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param build [String] The version of the build. E.g. '4.0.1 (38)'
      # @param count [Int] Number of issue
      # @param type [String] Issue type: all, crash or error
      # @param state [String] Issue state: all, open or closed
      # @return [Array<Fabricio::Model::Issue>]
      def top_issues(options = {})
        request_model = @request_model_factory.top_issues_request_model(options)
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body)['data']['project']['crashlytics']['_issues4Eg1Tv']['edges'].map do |edge|
          Fabricio::Model::Issue.new(edge['node'])
        end
      end

      # Obtains single issue
      #
      # @param issue_id [String] Issue identifier
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @return [Fabricio::Model::Issue]
      def single_issue(options = {})
        request_model = @request_model_factory.single_issue_request_model(options)
        response = @network_client.perform_request(request_model)
        Fabricio::Model::Issue.new(JSON.parse(response.body)['data']['project']['crashlytics']['_issueeUsmi'])
      end

      # Obtains issue session
      #
      # @param issue_id [String] Issue identifier
      # @param app_id [String] Application identifier
      # @param session_id [String] Session identifier
      # @return [Fabricio::Model::Issue]
      def issue_session(options = {})
        request_model = @request_model_factory.issue_session_request_model(options)
        response = @network_client.perform_request(request_model)
        json = JSON.parse(response.body)
        Fabricio::Model::IssueSession.new(json['data']['project']['crashlytics']['_session2RIRzK'])
      end

      # Add comment to issue
      #
      # @param app_id [String] Application identifier
      # @param issue_id [String] Issue identifier
      # @param message [String] Comment message
      # @return [JSON]
      def add_comment(options = {})
        request_model = @request_model_factory.add_comment_request_model(options)
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
      def oomfree(options = {})
        unless options[:start_time].nil? && options[:end_time].nil?
          start_date = Time.at(start_time.to_i).to_datetime
          end_date = Time.at(end_time.to_i).to_datetime
          days = (end_date - start_date).to_i + 1
          options[:days] = days
        end
        request_model = @request_model_factory.oom_count_request_model(options)
        response = @network_client.perform_request(request_model)

        result = JSON.parse(response.body)
        sessions = result['data']['project']['crashlytics']['oomSessionCounts']['timeSeries'][0]['allTimeCount']
        ooms = result['data']['project']['crashlytics']['oomCounts']['timeSeries'][0]['allTimeCount']
        1 - ooms.to_f / sessions
      end

      # Obtains the total count of a custom event type
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param event_type [String] Custom Event Name
      # @return [Array<Fabricio::Model::Point>]
      def custom_event_total(options = {})
        request_model = @request_model_factory.custom_event_total_request_model(options)
        response = @network_client.perform_request(request_model)
        parse_point_response(response)
      end

      # Obtains the unique device count of a custom event type
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param event_type [String] Custom Event Name
      # @return [Array<Fabricio::Model::Point>]
      def custom_event_unique_devices(options = {})
        request_model = @request_model_factory.custom_event_unique_devices_request_model(options)
        response = @network_client.perform_request(request_model)
        parse_point_response(response)
      end

      # Obtains the list of all attributes for a custom event type
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param event_type [String] Custom Event Name
      # @return [Array<Fabricio::Model::CustomEventAttributeName>]
      def all_custom_event_attribute(options = {})
        request_model = @request_model_factory.all_custom_event_attribute_request_model(options)
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body)['attribute_metadata'].map do |array|
          Fabricio::Model::CustomEventAttributeName.new(array)
        end
      end

      # Obtains the attribute counts of a custom event type
      #
      # @param organization_id [String] Organization identifier
      # @param app_id [String] Application identifier
      # @param start_time [String] Timestamp of the start date
      # @param end_time [String] Timestamp of the end date
      # @param event_type [String] Custom Event Name
      # @param event_attribute [String] Custom Event Attribute
      # @param selected_time [String] Timestamp of the selected date
      # @return [Array<Fabricio::Model::CustomEventAttributeValue>]
      def custom_event_attribute(options = {})
        request_model = @request_model_factory.custom_event_attribute_request_model(options)
        response = @network_client.perform_request(request_model)
        JSON.parse(response.body)['selected_day_top_values'].map do |array|
          Fabricio::Model::CustomEventAttributeValue.new(array)
        end
      end

      private

      def parse_point_response(response)
        JSON.parse(response.body)['series'].map do |array|
          Fabricio::Model::Point.new(array)
        end
      end

    end
  end
end
