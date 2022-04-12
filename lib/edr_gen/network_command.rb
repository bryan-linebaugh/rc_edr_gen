# frozen_string_literal: true

require 'etc'
require 'json'

module EdrGen
  # Defines and executes network activities
  class NetworkCommand
    def initialize(address, port, data)
      @logger = ActivityLogger.new
      @address = address
      @port = port
      @data = data
    end

    def run
      timestamp = Time.now.strftime('%Y-%m-%d %H:%M:%S.%L')
      pid = Process.spawn("#{@command} #{@file_path}")
      Process.detach(pid)

      @logger.log(format_activity(timestamp, pid))
    end

    private

    def username
      euid = Process.euid
      Etc.getpwuid(euid).name
    end

    def format_activity(timestamp, connection, process)
      {
        timestamp: timestamp,
        connection: connection,
        process: process
      }.to_json
    end
  end
end

# {
#   timestamp: timestamp,
#   connection: {
#     src_address: '',
#     dest_address: address,
#     port: port,
#     protocol: 'TCP',
#     size: 0
#   },
#   process: {
#     name: @command,
#     id: pid,
#     args: args,
#     username: username
#   }
# }
