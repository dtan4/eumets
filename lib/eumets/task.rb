require "ostruct"
require "rainbow"
require "time"

module Eumets
  class Task < OpenStruct
    def initialize(tasklist_id, params)
      super(params)
      # self.tasklist_id = tasklist_id
    end

    def completed?
      self.status == "completed"
    end

    def show
      text = if completed?
               Rainbow("#{status_icon}, #{self.due}, #{self.title}").green
             else
               Rainbow("#{status_icon}, ").red + Rainbow("#{self.due}").red.bright + Rainbow(", #{self.title}").red
             end

      puts text
    end

    def status_icon
      completed? ? "x" : "-"
    end
  end
end
