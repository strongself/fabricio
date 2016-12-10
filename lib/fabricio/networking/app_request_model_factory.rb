require 'json'
require 'fabricio/networking/request_model'
require 'fabricio/authorization/authorization_signer'

module Fabricio
  module Networking
    class AppRequestModelFactory
      include Fabricio::Authorization::AuthorizationSigner

      FABRIC_API_URL = 'https://fabric.io'
      FABRIC_INSTANT_API_URL = 'https://instant.fabric.io'
      FABRIC_GRAPHQL_API_URL = 'https://api-dash.fabric.io/graphql'
      FABRIC_API_PATH = '/api/v2'
      FABRIC_APPS_ENDPOINT = '/apps'
      FABRIC_ORGANIZATIONS_ENDPOINT = '/organizations'

      def all_apps_request_model(session)
        model = Fabricio::Networking::RequestModel.new(:GET,
                                                       FABRIC_API_URL,
                                                       FABRIC_API_PATH + FABRIC_APPS_ENDPOINT)
        sign_request_model(model, session)
        model
      end

      def get_app_request_model(session, app_id)
        path = "#{FABRIC_API_PATH}#{app_endpoint(app_id)}"
        model = Fabricio::Networking::RequestModel.new(:GET,
                                                       FABRIC_API_URL,
                                                       path)
        sign_request_model(model, session)
        model
      end

      def active_now_request_model(session, app_id)
        path = "#{FABRIC_API_PATH}#{org_app_endpoint(session, app_id)}#{growth_analytics_endpoint('active_now')}"
        model = Fabricio::Networking::RequestModel.new(:GET,
                                                       FABRIC_INSTANT_API_URL,
                                                       path)
        sign_request_model(model, session)
        model
      end

      def daily_new_request_model(session, app_id, start_time, end_time)
        path = "#{FABRIC_API_PATH}#{org_app_endpoint(session, app_id)}#{growth_analytics_endpoint('daily_new')}"
        headers = {
            'start' => start_time,
            'end' => end_time
        }
        model = Fabricio::Networking::RequestModel.new(:GET,
                                                       FABRIC_INSTANT_API_URL,
                                                       path,
                                                       headers)
        sign_request_model(model, session)
        model
      end

      def daily_active_request_model(session, app_id, start_time, end_time)
        path = "#{FABRIC_API_PATH}#{org_app_endpoint(session, app_id)}#{growth_analytics_endpoint('daily_active')}"
        headers = {
            'start' => start_time,
            'end' => end_time
        }
        model = Fabricio::Networking::RequestModel.new(:GET,
                                                       FABRIC_INSTANT_API_URL,
                                                       path,
                                                       headers)
        sign_request_model(model, session)
        model
      end

      def total_sessions_request_model(session, app_id, start_time, end_time)
        path = "#{FABRIC_API_PATH}#{org_app_endpoint(session, app_id)}#{growth_analytics_endpoint('total_sessions_scalar')}"
        headers = {
            'start' => start_time,
            'end' => end_time
        }
        model = Fabricio::Networking::RequestModel.new(:GET,
                                                       FABRIC_INSTANT_API_URL,
                                                       path,
                                                       headers)
        sign_request_model(model, session)
        model
      end

      def crash_count_request_model(session, app_id, start_time, end_time)
        headers = {
            'Content-Type' => 'application/json'
        }
        body = {
          'query' => "query AppScalars($app_id:String!,$type:IssueType!) {project(externalId:$app_id) {crashlytics {scalars:scalars(type:$type,start:#{start_time},end:#{end_time}) {crashes}}}}",
          'variables' => {
              'app_id' => app_id,
              'type' => 'crash'
          }
        }.to_json
        model = Fabricio::Networking::RequestModel.new(:POST,
                                                       FABRIC_GRAPHQL_API_URL,
                                                       '',
                                                       headers,
                                                       body)
        sign_request_model(model, session)
        model
      end

      def oom_count_request_model(session, app_id, days)
        headers = {
            'Content-Type' => 'application/json'
        }
        body = {
            'query' => 'query oomCountForDaysForBuild($app_id: String!, $builds: [String!]!, $days: Int!) { project(externalId: $app_id) { crashlytics{ oomCounts(builds: $builds, days: $days){ timeSeries{ allTimeCount } } oomSessionCounts(builds: $builds, days: $days){ timeSeries{ allTimeCount } } } } }',
            'variables' => {
                'app_id' => app_id,
                'days' => days,
                'builds' => [
                    'all'
                ]
            }
        }.to_json
        model = Fabricio::Networking::RequestModel.new(:POST,
                                                       FABRIC_GRAPHQL_API_URL,
                                                       '',
                                                       headers,
                                                       body)
        sign_request_model(model, session)
        model
      end

      private

      def app_endpoint(app_id)
        "/#{FABRIC_APPS_ENDPOINT}/#{app_id}"
      end

      def org_endpoint(session)
        "/#{FABRIC_ORGANIZATIONS_ENDPOINT}/#{session.organization_id}"
      end

      def org_app_endpoint(session, app_id)
        "#{org_endpoint(session)}/#{app_endpoint(app_id)}"
      end

      def growth_analytics_endpoint(name)
        "/growth_analytics/#{name}.json"
      end
    end
  end
end
