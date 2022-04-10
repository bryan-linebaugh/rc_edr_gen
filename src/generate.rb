#!/usr/bin/env ruby

# frozen_string_literal: true

require 'rubygems'
require 'thor'
require 'etc'
require 'logger'
require 'json'

# Generates activity monitored by EDR agents. Supports Unix platforms
class ActivityGenerator < Thor
  desc 'file FILE_PATH FILE_ACTION', 'Create, modify or delete a file'
  def file(file_path, file_action)
    command = nil
    timestamp = nil
    pid = nil

    euid = Process.euid
    username = Etc.getpwuid(euid).name

    case file_action
    when 'create'
      # Check if file exists, if so throw error with message
      command = 'touch'
      timestamp = Time.now.strftime('%Y-%m-%d %H:%M:%S.%L')
      pid = Process.spawn("#{command} #{file_path}")
      Process.detach(pid)
    when 'modify'
      # Check if file exists, if not throw error with message
      command = 'touch'
      timestamp = Time.now.strftime('%Y-%m-%d %H:%M:%S.%L')
      pid = Process.spawn("#{command} #{file_path}")
      Process.detach(pid)
    when 'delete'
      # Check if file exists, if not throw error with message
      command = 'rm'
      timestamp = Time.now.strftime('%Y-%m-%d %H:%M:%S.%L')
      pid = Process.spawn("#{command} #{file_path}")
      Process.detach(pid)
    else
      puts 'Bad action'
    end

    logger = Logger.new('log/activity.log')
    logger.info(
      {
        timestamp: timestamp,
        action: file_action,
        path: file_path,
        process: {
          name: command,
          id: pid,
          args: '',
          username: username
        }
      }.to_json
    )
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

ActivityGenerator.start
