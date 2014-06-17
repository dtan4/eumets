module Eumets
  module Util
    def call_api(api_client, method, options = {})
      JSON.parse(api_client.execute(method, options).response.body, symbolize_names: true)
    end
  end
end
