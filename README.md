# edr_gen

`edr_gen` is a command-line tool that allows you to trigger different activities that are typically monitored by EDR agents. The tool is built using the [Thor](https://github.com/rails/thor) CLI toolkit to define it's commands, options and parse arguments. The tool accepts different activity types: `file`, `network`, `process` and their required arguments to trigger the specific activity. An activity is performed on the system by [spawning](https://ruby-doc.org/core-2.6.3/Process.html#method-c-spawn) a process to run a command or process implementing the activity. Most activities triggered by the tool are implemented using system-specific commands (`touch`, `rm` etc.). Due to this, tool only supports Unix based systems (macOS and Linux). Details about each activity triggered by the tool will be logged to `log/activty.log` in the project's root directory.

## Requirements

- Ruby 2.0+

## Installation

1. Clone the repository

```
$ git clone 'https://github.com/bryan-linebaugh/rc_edr_gen.git'
```

2. Install the gem (from the project root)

```
$ gem install edr_gen
```

## Usage

Details about the usage of the tool and the activities available can be displayed by running:

```
$ edr_gen help

Commands:
  edr_gen file 'FILE_PATH' FILE_ACTION  # Create, modify or delete a file
  edr_gen help [COMMAND]                # Describe available commands or one specific command
  edr_gen network ADDRESS PORT          # Establish a network connection and transmit data
  edr_gen process 'PROCESS_PATH'        # Starts a process, given a path to an executable file and optional command-line arguments
```

or just an activity if you specify it:

```
$ edr_gen help file

Usage:
  edr_gen file 'FILE_PATH' FILE_ACTION

Create, modify or delete a file
```

Trigger a 'file create' activity

```
$ edr_gen file hello_world.txt create
```

Trigger a 'file delete' activity

```
$ edr_gen file hello_world.txt delete
```
