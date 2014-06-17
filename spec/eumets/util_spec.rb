require "spec_helper"

module Eumets
  module Util
    class DummyClass
      include Eumets::Util
    end

    describe "#call_api" do
      let(:instance) do
        DummyClass.new
      end

      let(:api_client) do
        double("api_client", execute: response)
      end

      let(:response) do
        double("response", response: body)
      end

      let(:body) do
        double("body", body: "{}")
      end

      let(:method) do
        "method"
      end

      let(:options) do
        {}
      end

      it "should call API" do
        expect(api_client).to receive(:execute).with(method, options)
        instance.call_api(api_client, method, options)
      end
    end
  end
end
