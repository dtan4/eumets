require "spec_helper"
require "rainbow"
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

    let(:due) do
      "2014-05-18"
    end

    let(:status) do
      "completed"
    end

    let(:api_client) do
      double("api_client")
    end

    let(:tasks_client) do
      double("tasks_client")
    end

    let(:options) do
      { showCompleted: false }
    end

    let(:tasklist) do
      { id: "id" }
    end

    describe "#all" do
      before do
        allow(described_class).to receive(:tasklists).and_return([tasklist])
        allow(described_class).to receive(:insert_task).and_return(nil)
      end

      it "should add new task" do
        expect(described_class).to receive(:tasklists).with(api_client, tasks_client)
        expect(described_class).to receive(:insert_task).with(api_client, tasks_client, tasklist, options).once
        described_class.add(api_client, tasks_client, options)
      end
    end

    describe "#find_by" do
      before do
        allow(described_class).to receive(:tasklists).and_return([tasklist])
        allow(described_class).to receive(:taskitems).and_return([])
      end

      it "should get incompleted task list" do
        expect(described_class).to receive(:tasklists).with(api_client, tasks_client)
        expect(described_class).to receive(:taskitems).with(api_client, tasks_client, tasklist, options).once
        described_class.find_by(api_client, tasks_client, options)
      end
    end

    describe "#initialize" do
      context "deadline is given" do
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
      context "completed" do
        it "should return true" do
          expect(task.completed?).to be true
        end
      end

      context "incompleted" do
        let(:status) do
          "incompleted"
        end

        it "should return false" do
          expect(task.completed?).to be false
        end
      end
    end

    describe "#show" do
      let(:stdout) do
        double
      end

      before do
        allow(stdout).to receive(:puts)
      end

      context "completed" do
        it "should print task" do
          expect(stdout).to receive(:puts).with(Rainbow("x 2014-05-18 title").green)
          task.show(stdout)
        end
      end

      context "expired" do
        let(:status) do
          "incompleted"
        end

        it "should print task" do
          allow(task).to receive(:expired?).and_return(true)
          expect(stdout).to receive(:puts).with(Rainbow("- ").red + Rainbow("2014-05-18").red.bright + Rainbow(" title").red)
          task.show(stdout)
        end
      end

      context "incompleted" do
        let(:status) do
          "incompleted"
        end

        it "should print task" do
          allow(task).to receive(:expired?).and_return(false)
          expect(stdout).to receive(:puts).with("- 2014-05-18 title")
          task.show(stdout)
        end
      end
    end
  end
end
