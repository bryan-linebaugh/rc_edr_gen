#!/usr/bin/env ruby

# frozen_string_literal: true

require 'rubygems'
require 'thor'

require_relative 'file_command'

module EdrGen
  # Generates activity monitored by EDR agents. Supports Unix platforms
  class EdrGen < Thor
    desc 'file FILE_PATH FILE_ACTION', 'Create, modify or delete a file'
    def file(file_path, file_action)
      command = FileCommand.new(file_path, file_action)
      command.run
    rescue FileCommand::InvalidFileActionError
      puts 'Caught an exception'
    end

    desc 'network ADDRESS PORT DATA', 'Establish a network connection and transmit data'
    def network(address, port, data)
      puts "Address: #{address}"
      puts "Port: #{port}"
      puts "Message: #{data}"
    end

    desc 'process PATH [ARGS]', 'Starts a process, given a path to an executable file and optional command-line arguments'
    method_option :args, aliases: '-a', desc: 'Optional command-line arguments for the process'
    def process(file_path, *args)
      puts "File Path: #{file_path}"
      puts "Args: #{args}"
      puts 'Generated Process Activity'
    end

    def self.exit_on_failure?
      true
    end
  end
end

EdrGen::EdrGen.start
