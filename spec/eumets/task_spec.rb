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
       status: status,
       due: due,
       hidden: false,
       links: []
      }
    end

    let(:task) do
      described_class.new(tasklist_id, params)
    end

    describe "#initialize" do
      let(:status) do
        "completed"
      end

      context "deadline is given" do
        let(:due) do
          "2014-05-18"
        end

        it "should set instance variables" do
          task = described_class.new(tasklist_id, params)
          expect(task.id).to eq "id"
          expect(task.title).to eq "title"
          expect(task.due).to eq Time.parse("2014-05-18")
          expect(task.notes).to eq "notes"
        end
      end

      context "deadline is not given" do
        let(:due) do
          nil
        end

        it "should set instance variables" do
          task = described_class.new(tasklist_id, params)
          expect(task.id).to eq "id"
          expect(task.title).to eq "title"
          expect(task.due).to eq nil
          expect(task.notes).to eq "notes"
        end
      end
    end

    describe "#completed?" do
      let(:due) do
        "2014-05-18"
      end

      context "when complete status is true" do
        let(:status) do
          "completed"
        end

        it "should return true" do
          expect(task.completed?).to be true
        end
      end

      context "when complete status is false" do
        let(:status) do
          "incompleted"
        end

        it "should return false" do
          expect(task.completed?).to be false
        end
      end
    end

    describe "#status_icon" do
      let(:due) do
        "2014-05-18"
      end

      context "when complete status is true" do
        let(:status) do
          "completed"
        end

        it "should return x" do
          expect(task.status_icon).to eq "x"
        end
      end

      context "when complete status is false" do
        let(:status) do
          "incompleted"
        end

        it "should return -" do
          expect(task.status_icon).to eq "-"
        end
      end
    end
  end
end
