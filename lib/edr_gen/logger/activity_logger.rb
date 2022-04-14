# frozen_string_literal: true

require 'logger'

module EdrGen
  # Logs activity data
  class ActivityLogger
    def initialize
      @logger = Logger.new('log/activity.log')
    end

    def log(message)
      @logger.info message
    end
  end
end
