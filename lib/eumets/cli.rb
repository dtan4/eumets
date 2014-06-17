require "json"

module Eumets
  class Cli
    include Util

    def initialize(auth = true)
      @api_client, @tasks_client = Eumets::Auth.authorize if auth
    end

    def add(options = {})
      raise UnauthorizedException unless authorized?
      Eumets::Task.add(@api_client, @tasks_client, options)
    end

    def list(options = {})
      raise UnauthorizedException unless authorized?
      Eumets::Task.find_by(@api_client, @tasks_client, options)
    end

    private

    def authorized?
      !@tasks_client.nil?
    end
  end

  class UnauthorizedException < Exception; end
end
