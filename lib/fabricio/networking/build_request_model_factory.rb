require 'fabricio/networking/request_model'
require 'fabricio/authorization/authorization_signer'

module Fabricio
  module Networking
    class BuildRequestModelFactory
      include Fabricio::Authorization::AuthorizationSigner

      FABRIC_API_URL = 'https://fabric.io'
      FABRIC_API_PATH = '/api/v2'
      FABRIC_APPS_ENDPOINT = '/apps'
      FABRIC_ORGANIZATIONS_ENDPOINT = '/organizations'

      def all_builds_request_model(session, app_id)
        path = "#{FABRIC_API_PATH}#{org_app_endpoint(session, app_id)}/beta_distribution/releases"
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = path
        end
        sign_request_model(model, session)
        model
      end

      def get_build_request_model(session, app_id, version, build_number)
        path = "#{FABRIC_API_PATH}#{org_app_endpoint(session, app_id)}/beta_distribution/releases"
        params = {
            'app[display_version]' => version,
            'app[build_version]' => build_number
        }
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = path
          config.params = params
        end
        sign_request_model(model, session)
        model
      end

      def top_versions_request_model(session, app_id, start_time, end_time)
        path = "#{FABRIC_API_PATH}#{org_app_endpoint(session, app_id)}/growth_analytics/top_builds"
        params = {
            'app_id' => app_id,
            'start' => start_time,
            'end' => end_time
        }
        model = Fabricio::Networking::RequestModel.new do |config|
          config.type = :GET
          config.base_url = FABRIC_API_URL
          config.api_path = path
          config.params = params
        end
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

    end
  end
end
