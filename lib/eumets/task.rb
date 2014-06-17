require "rainbow"
require "time"

module Eumets
  class Task
    include Util
    extend Util

    STRING_KEYS = %i(kind id etag title selfLink parent position notes status)
    DATETIME_KEYS = %i(updated due completed)
    BOOL_KEYS = %i(deleted hidden)

    def self.add(api_client, tasks_client, options)
      tasklists(api_client, tasks_client).each do |tasklist|
        insert_task(api_client, tasks_client, tasklist, options)
      end
    end

    def self.all(api_client, tasks_client)
      self.find_by(api_client, tasks_client, {})
    end

    def self.find_by(api_client, tasks_client, options = {})
      tasklists(api_client, tasks_client).inject([]) do |tasks, tasklist|
        taskitems(api_client, tasks_client, tasklist, options).each do |task|
          tasks << Task.new(tasklist[:id], task)
        end

        tasks
      end.flatten
    end

    def initialize(tasklist_id, params)
      @params = params
      @tasklist_id = tasklist_id
    end

    (STRING_KEYS + BOOL_KEYS).each do |key|
      define_method(key) { @params[key] }
    end

    DATETIME_KEYS.each do |key|
      define_method(key) { @params[key] ? Time.parse(@params[key]) : nil }
    end

    def completed?
      status == "completed"
    end

    def show_date(datetime)
      datetime ? datetime.strftime("%Y-%m-%d") : " " * (4 + 1 + 2 + 1 + 2)
    end

    def show
      text = if completed?
               completed_text
             elsif due && (Time.now > due)
               expired_text
             else
               incompleted_text
             end

      puts text
    end

    def status_icon
      completed? ? "x" : "-"
    end

    private

    def self.insert_task(api_client, tasks_client, tasklist, options)
      call_api(api_client, tasks_client.tasks.insert, options.merge(tasklist: tasklist[:id]))
    end

    def self.tasklists(api_client, tasks_client)
      call_api(api_client, tasks_client.tasklists.list, {})[:items]
    end

    def self.taskitems(api_client, tasks_client, tasklist, options)
      call_api(api_client, tasks_client.tasks.list, options.merge(tasklist: tasklist[:id]))[:items]
    end

    def completed_text
      Rainbow("#{status_icon} #{show_date(due)} #{title}").green
    end

    def expired_text
      Rainbow("#{status_icon} ").red + Rainbow("#{show_date(due)}").red.bright + Rainbow(" #{title}").red
    end

    def incompleted_text
      Rainbow("#{status_icon} ").magenta + Rainbow("#{show_date(due)}").magenta.bright + Rainbow(" #{title}").magenta
    end
  end
end
