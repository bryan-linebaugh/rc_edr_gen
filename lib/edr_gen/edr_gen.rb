#!/usr/bin/env ruby

# frozen_string_literal: true

require 'thor'

require 'edr_gen/commands/file_command'
require 'edr_gen/commands/network_command'
require 'edr_gen/commands/process_command'

module EdrGen
  # Generates activity monitored by EDR agents. Supports Unix platforms
  class EdrGen < Thor
    desc 'file \'FILE_PATH\' FILE_ACTION', 'Create, modify or delete a file'
    def file(file_path, file_action)
      command = FileCommand.new(file_path, file_action)
      command.run
    rescue FileCommand::InvalidFileActionError
      puts 'ERROR: Invalid file action specified. Available actions: create, modify or delete.'
    rescue FileCommand::InvalidFileError
      puts 'ERROR: Specified file not found. Create the file before generating other activity.'
    end

    desc 'network ADDRESS PORT', 'Establish a network connection and transmit data'
    method_option :data, aliases: '-d', desc: 'Optionally specify messages to send. Example: \'test\''
    def network(address, port)
      command = NetworkCommand.new(address, port, options[:data])
      command.run
    end

    desc 'process \'PROCESS_PATH\'', 'Starts a process, given a path to an executable file and optional command-line arguments'
    method_option :args, aliases: '-a', desc: 'Optional command-line arguments for the process. Example: \'rtla\''
    method_option :hypenated, aliases: '-h', desc: 'Flag to set if command-line arguments require a hyphen prefix'
    def process(process_path)
      command = ProcessCommand.new(process_path, options)
      command.run
    rescue ProcessCommand::ProcessNotFoundError
      puts 'ERROR: Process not found, invalid file path.'
    end

    def self.exit_on_failure?
      true
    end
  end
end
