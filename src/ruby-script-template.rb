#!/usr/bin/env ruby
# frozen_string_literal: true.

# -------------------------------------------------------------------------------- #
# Description                                                                      #
# -------------------------------------------------------------------------------- #
# This is a simple ruby script wrapper designed to allow you to quickly put write  #
# standard scrips in a standard way.                                               #
# -------------------------------------------------------------------------------- #

require 'colorize'
require 'etc'
require 'optparse'

# -------------------------------------------------------------------------------- #
# Flags                                                                            #
# -------------------------------------------------------------------------------- #
# A set of global flags that we use for configuration.                             #
# -------------------------------------------------------------------------------- #

$VERBOSE = false                    # Should we give verbose output ?
$ZERO_INPUT = false                 # Do we require any user input ?
$USE_COLOURS = true                 # Should we use colours in our output ?
$ROOT_ONLY = false                  # Should the script be run only by the root user ?

$script_info = {}                   # Information about the script

# -------------------------------------------------------------------------------- #
# The wrapper function                                                             #
# -------------------------------------------------------------------------------- #
# This is where you code goes and is effectively your main() function.             #
# -------------------------------------------------------------------------------- #

def wrapper(options = {})
    puts 'I got here!!'.green

    puts 'Verbose!'.green if $VERBOSE

    puts "Options: #{options}"
end

# -------------------------------------------------------------------------------- #
# Process Arguments                                                                #
# -------------------------------------------------------------------------------- #
# This function will process the input from the command line and work out what it  #
# is that the user wants to see.                                                   #
#                                                                                  #
# This is the main processing function where all the processing logic is handled.  #
# -------------------------------------------------------------------------------- #

def process_arguments
    options = {}
    # Enforce the presence of
    mandatory = [:c]

    optparse = OptionParser.new do |opts|
        opts.banner = "Usage: #{$PROGRAM_NAME}"

        opts.on('-h', '--help', 'Display this screen') do
            puts opts
            clean_exit(1)
        end
        opts.on('-v', '--verbose', 'Enable verbose output') do |_verbose|
            $VERBOSE = true
        end

        opts.on('-a', '--a', 'A test flag') do |_a|
            options[:a] = true
        end
        opts.on('-b', '--b number', Integer, 'A test integer value') do |b|
            options[:b] = b
        end
        opts.on('-c', '--c string', 'A test string value') do |c|
            options[:c] = c
        end
    end

    begin
        optparse.parse!
        missing = mandatory.select { |param| options[param].nil? }
        raise OptionParser::MissingArgument.new(missing.join(', ')) unless missing.empty?
    rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e
        show_error(e.to_s)
        puts optparse
        clean_exit
    end

    wrapper(options)
    clean_exit
end

# -------------------------------------------------------------------------------- #
# STOP HERE!                                                                       #
# -------------------------------------------------------------------------------- #
# The functions below are part of the template and should not require any changes  #
# in order to make use of this template. If you are going to edit code beyound     #
# this point please ensure you fully understand the impact of those changes!       #
# -------------------------------------------------------------------------------- #

# -------------------------------------------------------------------------------- #
# Utiltity Functions                                                               #
# -------------------------------------------------------------------------------- #
# The following functions are all utility functions used within the script but are #
# not specific to the display of the colours and only serve to handle things like, #
# signal handling, user interface and command line option processing.              #
# -------------------------------------------------------------------------------- #

# -------------------------------------------------------------------------------- #
# Show Error                                                                       #
# -------------------------------------------------------------------------------- #
# A simple wrapper function to show something was an error.                        #
# -------------------------------------------------------------------------------- #

def show_error(message = nil)
    return if message.nil?

    real_show_messge(message, :red)
end

# -------------------------------------------------------------------------------- #
# Show Warning                                                                     #
# -------------------------------------------------------------------------------- #
# A simple wrapper function to show something was a warning.                       #
# -------------------------------------------------------------------------------- #

def show_warning(message = nil)
    return if message.nil?

    real_show_messge(message, :yellow)
end

# -------------------------------------------------------------------------------- #
# Show Success                                                                     #
# -------------------------------------------------------------------------------- #
# A simple wrapper function to show something was a success.                       #
# -------------------------------------------------------------------------------- #

def show_success(message = nil)
    return if message.nil?

    real_show_messge(message, :green)
end

# -------------------------------------------------------------------------------- #
# Show Success                                                                     #
# -------------------------------------------------------------------------------- #
# A simple wrapper function to show something was a success.                       #
# -------------------------------------------------------------------------------- #

def real_show_messge(message, colour)
    return if message.nil?

    if $USE_COLOURS
        puts message.colorize(colour)
    else
        puts message
    end
end

# -------------------------------------------------------------------------------- #
# Check Root                                                                       #
# -------------------------------------------------------------------------------- #
# If required ensure the script is running as the root user.                       #
# -------------------------------------------------------------------------------- #

def check_root
    clean_exit(1, 'This script must be run as root') unless Etc.getpwuid.uid.zero?
end

# -------------------------------------------------------------------------------- #
# Clean Exit                                                                       #
# -------------------------------------------------------------------------------- #
# Unset the traps and exit cleanly, with an optional exit code / message.          #
# -------------------------------------------------------------------------------- #

def clean_exit(exit_code = 0, error_message = nil)
    show_error(error_message) unless error_message.nil?
    exit(exit_code)
end

# -------------------------------------------------------------------------------- #
# Get Script Info                                                                  #
# -------------------------------------------------------------------------------- #
# Work out some basic facts about the script, how it was called, where it lives,   #
# what it is called etc.                                                           #
# -------------------------------------------------------------------------------- #

def gather_script_info
    $script_info[:FILE_NAME] = File.basename($PROGRAM_NAME)
    $script_info[:FULL_PATH] = File.expand_path File.dirname($PROGRAM_NAME)

    $script_info[:INVOKED_FILE] = $PROGRAM_NAME
    $script_info[:INVOKED_PATH] = File.dirname($PROGRAM_NAME)

    $script_info[:SCRIPT_ARGS] = ARGV
end

# -------------------------------------------------------------------------------- #
# Main()                                                                           #
# -------------------------------------------------------------------------------- #
# The main function where all of the heavy lifting and script config is done.      #
# -------------------------------------------------------------------------------- #

def main
    check_root if $ROOT_ONLY
    gather_script_info
    process_arguments
end

main

# -------------------------------------------------------------------------------- #
# End of Script                                                                    #
# -------------------------------------------------------------------------------- #
# This is the end - nothing more to see here.                                      #
# -------------------------------------------------------------------------------- #
