require "google/api_client"
require "google/api_client/client_secrets"
require "google/api_client/auth/file_storage"
require "google/api_client/auth/installed_app"
require "json"

module Eumets
  class Cli
    include Util

    OAUTH_SCOPE = "https://www.googleapis.com/auth/tasks"

    def initialize
      @api_client = Google::APIClient.new(application_name: "eumets", application_version: "1.0.0")
      @credential_file = File.join(ENV["HOME"], ".eumets", "oauth2.json")
      @client_secrets_file = File.join(ENV["HOME"], ".eumets", "client-secrets.json")
    end

    def authorize!
      file_storage = Google::APIClient::FileStorage.new(@credential_file)

      if file_storage.authorization.nil?
        client_secrets = Google::APIClient::ClientSecrets.load(@client_secrets_file)
        flow = Google::APIClient::InstalledAppFlow.new(
                                                       client_id: client_secrets.client_id,
                                                       client_secret: client_secrets.client_secret,
                                                       scope: [OAUTH_SCOPE]
                                                      )
        @api_client.authorization = flow.authorize(file_storage)
        @tasks_client = get_tasks_client
      else
        @api_client.authorization = file_storage.authorization
        @tasks_client = get_tasks_client
      end
    end

    def list(options = {})
      raise UnauthorizedException unless authorized?
      Eumets::Task.find_by(@api_client, @tasks_client, options)
    end

    private

    def authorized?
      !@tasks_client.nil?
    end

    def get_tasks_client
      @api_client.discovered_api("tasks", "v1")
    end
  end

  class UnauthorizedException < Exception; end
end
