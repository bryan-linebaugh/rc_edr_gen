# frozen_string_literal: true

require 'etc'
require 'json'

require 'edr_gen/logger/activity_logger'

module EdrGen
  # Defines and executes process activities
  class ProcessCommand
    class ProcessNotFoundError < StandardError; end

    def initialize(process_path, options)
      @logger = ActivityLogger.new
      @process_path = process_path
      @args = options[:args]
      @hypenated = options[:hypenated]
    end

    def run
      timestamp = Time.now.strftime('%Y-%m-%d %H:%M:%S.%L')

      raise ProcessNotFoundError unless File.exist? @process_path

      command = if @hypenated
                  "#{@process_path} -#{@args}"
                else
                  "#{@process_path} #{@args}"
                end

      pid = Process.spawn(command, out: '/dev/null')
      Process.detach(pid)

      process_details = {
        name: command,
        args: @args,
        id: pid,
        username: username
      }

      @logger.log(format_activity(timestamp, process_details))
    end

    private

    def username
      euid = Process.euid
      Etc.getpwuid(euid).name
    end

    def format_activity(timestamp, process_details)
      {
        timestamp: timestamp,
        process: process_details
      }.to_json
    end
  end
end
