require "rainbow"
require "time"

module Eumets
  class Task
    STRING_KEYS = %i(kind id etag title selfLink parent position notes status)
    DATETIME_KEYS = %i(updated due completed)
    BOOL_KEYS = %i(deleted hidden)

    def initialize(tasklist_id, params)
      @params = params
      @tasklist_id = tasklist_id
    end

    (STRING_KEYS + BOOL_KEYS).each do |key|
      define_method(key) { @params[key] }
    end

    DATETIME_KEYS.each do |key|
      define_method(key) { Time.parse(@params[key]) }
    end

    def completed?
      status == "completed"
    end

    def show
      text = if completed?
               Rainbow("#{status_icon}, #{due}, #{title}").green
             else
               Rainbow("#{status_icon}, ").red + Rainbow("#{due}").red.bright + Rainbow(", #{title}").red
             end

      puts text
    end

    def status_icon
      completed? ? "x" : "-"
    end
  end
end
