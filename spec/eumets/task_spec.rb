# -*- coding: utf-8 -*-
require "spec_helper"
require "time"

module Eumets
  describe Task do
    let(:completed_params) do
      {
       id: "id",
       title: "title",
       updated: "2014-05-18",
       notes: "notes",
       status: "completed",
       due: "2014-05-18"
      }
    end

    let(:incompleted_params) do
      {
       id: "id",
       title: "title",
       updated: "2014-05-18",
       notes: "notes",
       status: "needsAction",
       due: "2014-05-18"
      }
    end

    describe "#initialize" do
      it "should set instance variables" do
        task = described_class.new(completed_params)
        expect(task.id).to eq "id"
        expect(task.title).to eq "title"
        expect(task.updated).to eq Time.parse(completed_params[:updated])
        expect(task.notes).to eq "notes"
        expect(task.completed).to be_true
        expect(task.due).to eq Time.parse(completed_params[:due])
      end
    end

    describe "#status_icon" do
      context "when the complete status is true" do
        it "should return ○" do
          task = described_class.new(completed_params)
          expect(task.status_icon).to eq "○"
        end
      end

      context "when the complete status is false" do
        it "should return ×" do
          task = described_class.new(incompleted_params)
          expect(task.status_icon).to eq "×"
        end
      end
    end
  end
end
