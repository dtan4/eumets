require "spec_helper"

module Eumets
  describe Cli do
    let(:cli) do
      described_class.new
    end

    shared_context "authorized" do
      it "should not raise any Exception" do
        allow_any_instance_of(described_class).to receive(:authorized?).and_return(true)
        expect { action }.not_to raise_error
      end
    end

    shared_context "unauthorized" do
      it "should raise UnauthorizedException" do
        allow_any_instance_of(described_class).to receive(:authorized?).and_return(false)
        expect { action }.to raise_error UnauthorizedException
      end
    end

    describe "#list" do
      let(:action) do
        cli.list
      end

      before do
        allow(Eumets::Task).to receive(:find_by).and_return([])
      end

      include_context "authorized"
      include_context "unauthorized"
    end

    describe "#add" do
      let(:action) do
        cli.add
      end

      before do
        allow(Eumets::Task).to receive(:add).and_return(nil)
      end

      include_context "authorized"
      include_context "unauthorized"
    end
  end
end
