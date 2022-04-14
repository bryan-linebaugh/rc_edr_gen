# frozen_string_literal: true

require 'etc'
require 'json'
require 'socket'

require 'edr_gen/logger/activity_logger'

module EdrGen
  # Defines and executes network activities
  class NetworkCommand
    def initialize(address, port, data)
      @logger = ActivityLogger.new
      @hostname = hostname
      @address = address
      @port = port
      @data = data || 'test'
      @command = "echo #{@data} | nc #{@address} #{@port}"
    end

    def run
      timestamp = Time.now.strftime('%Y-%m-%d %H:%M:%S.%L')

      pid = Process.spawn(@command)
      Process.detach(pid)

      process_details = {
        name: @command,
        id: pid,
        username: username
      }

      connection_details = {
        source: @hostname,
        destination: @address,
        port: @port,
        protocol: 'TCP',
        size: @data.bytesize
      }

      @logger.log(format_activity(timestamp, connection_details, process_details))
    end

    private

    def hostname
      Socket.gethostname
    end

    def username
      euid = Process.euid
      Etc.getpwuid(euid).name
    end

    def format_activity(timestamp, connection_details, process_details)
      {
        timestamp: timestamp,
        connection: connection_details,
        process: process_details
      }.to_json
    end
  end
end
