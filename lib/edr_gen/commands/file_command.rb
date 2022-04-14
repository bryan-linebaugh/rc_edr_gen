# frozen_string_literal: true

require 'etc'
require 'json'

require 'edr_gen/logger/activity_logger'

module EdrGen
  # Defines and executes file activities
  class FileCommand
    class InvalidFileActionError < StandardError; end
    class InvalidFileError < StandardError; end

    def initialize(file_path, file_action)
      @logger = ActivityLogger.new
      @file_path = file_path
      @file_action = file_action
      @command = get_command(file_action)
    end

    def run
      timestamp = Time.now.strftime('%Y-%m-%d %H:%M:%S.%L')

      if !File.exist?(@file_path) && (@file_action == 'modify' || @file_action == 'delete')
        raise InvalidFileError
      end

      pid = Process.spawn("#{@command} #{@file_path}")
      Process.detach(pid)

      process_details = {
        name: @command,
        id: pid,
        username: username
      }

      @logger.log(format_activity(timestamp, process_details))
    end

    private

    def get_command(file_action)
      case file_action
      when 'create'
        'touch'
      when 'modify'
        'touch -c'
      when 'delete'
        'rm'
      else
        raise InvalidFileActionError
      end
    end

    def username
      euid = Process.euid
      Etc.getpwuid(euid).name
    end

    def format_activity(timestamp, process_details)
      {
        timestamp: timestamp,
        action: @file_action,
        path: @file_path,
        process: process_details
      }.to_json
    end
  end
end
