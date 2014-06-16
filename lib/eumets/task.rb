require "ostruct"
require "time"

module Eumets
  class Task < OpenStruct
    def initialize(tasklist_id, params)
      super(params)
      self.tasklist_id = tasklist_id
    end

    def completed?
      self.status == "completed"
    end

    def status_icon
      completed? ? "x" : "-"
    end
  end
end
