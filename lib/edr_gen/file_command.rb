# frozen_string_literal: true

require 'etc'
require 'json'

require_relative 'logger/activity_logger.rb'

module EdrGen
  # Defines and executes file activities
  class FileCommand
    class InvalidFileActionError < StandardError; end

    def initialize(file_path, file_action)
      @logger = ActivityLogger.new
      @file_path = file_path
      @file_action = file_action
      @command = get_command(file_action)
    end

    def run
      timestamp = Time.now.strftime('%Y-%m-%d %H:%M:%S.%L')
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
      when 'create', 'modify'
        'touch'
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

    def format_activity(timestamp, process)
      {
        timestamp: timestamp,
        action: @file_action,
        path: @file_path,
        process: process
      }.to_json
    end
  end
end
