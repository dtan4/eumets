# -*- coding: utf-8 -*-
require "time"

module Eumets
  class Task
    attr_reader :id, :title, :updated, :notes, :completed, :due

    def initialize(params)
      @id = params[:id]
      @title = params[:title]
      @updated = Time.parse(params[:updated])
      @notes = params[:notes]
      @completed = (params[:status] == "completed")
      @due = Time.parse(params[:due])
    end

    def status_icon
      @completed ? "○" : "×"
    end
  end
end
