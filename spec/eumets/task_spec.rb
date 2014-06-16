require "spec_helper"
require "time"

module Eumets
  describe Task do
    let(:tasklist_id) do
      "tasklist_id"
    end

    let(:params) do
      {
       kind: "tasks#task",
       id: "id",
       etag: "etag",
       title: "title",
       updated: "2014-05-18",
       selfLink: "selfLink",
       parent: "parent",
       method: "method",
       notes: "notes",
       status: "completed",
       due: "2014-05-18",
       hidden: false,
       links: []
      }
    end

    let(:completed_params) do
      params[:status] = "completed"
      params
    end

    let(:incompleted_params) do
      params[:status] = "needsAction"
      params
    end

    describe "#initialize" do
      it "should set instance variables" do
        task = described_class.new(tasklist_id, completed_params)
        expect(task.id).to eq "id"
        expect(task.title).to eq "title"
        expect(task.updated).to eq Time.parse("2014-05-18")
        expect(task.notes).to eq "notes"
      end
    end

    let(:task) do
      described_class.new(tasklist_id, arg)
    end

    describe "#completed?" do
      context "when complete status is true" do
        let(:arg) do
          completed_params
        end

        it "should return true" do
          expect(task.completed?).to be true
        end
      end

      context "when complete status is false" do
        let(:arg) do
          incompleted_params
        end

        it "should return false" do
          expect(task.completed?).to be false
        end
      end
    end

    describe "#status_icon" do
      context "when complete status is true" do
        let(:arg) do
          completed_params
        end

        it "should return x" do
          expect(task.status_icon).to eq "x"
        end
      end

      context "when complete status is false" do
        let(:arg) do
          incompleted_params
        end

        it "should return -" do
          expect(task.status_icon).to eq "-"
        end
      end
    end
  end
end
