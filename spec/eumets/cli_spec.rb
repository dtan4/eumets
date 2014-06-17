require "spec_helper"

module Eumets
  describe Cli do
    let(:cli) do
      described_class.new
    end

    describe "#list" do
      let(:list) do
        cli.list
      end

      before do
        allow(Eumets::Task).to receive(:find_by).and_return([])
      end

      context "authorized" do
        before do
          allow_any_instance_of(described_class).to receive(:authorized?).and_return(true)
        end

        it "should not raise UnauthorizedException" do
          expect { list }.not_to raise_error
        end
      end

      context "unauthorized" do
        before do
          allow_any_instance_of(described_class).to receive(:authorized?).and_return(false)
        end

        it "should raise UnauthorizedException" do
          expect { list }.to raise_error UnauthorizedException
        end
      end
    end

    describe "#add" do
      let(:add) do
        cli.add
      end

      before do
        allow(Eumets::Task).to receive(:add).and_return(nil)
      end

      context "authorized" do
        before do
          allow_any_instance_of(described_class).to receive(:authorized?).and_return(true)
        end

        it "should not raise any Exception" do
          expect { add }.not_to raise_error
        end
      end

      context "unauthorized" do
        before do
          allow_any_instance_of(described_class).to receive(:authorized?).and_return(false)
        end

        it "should raise UnauthorizedException" do
          expect { add }.to raise_error UnauthorizedException
        end
      end
    end
  end
end
