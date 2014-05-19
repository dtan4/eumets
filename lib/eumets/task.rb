require "ostruct"
require "time"

module Eumets
  class Task < OpenStruct
    def initialize(tasklist_id, params)
      super(params)
      self.tasklist_id = tasklist_id
    end

    def status_icon
      self.status == "completed" ? "x" : "-"
    end
  end
end
