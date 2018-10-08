require 'optparse'
require 'pry'

# encoding: utf-8

class OptParse
  Version = '0.1'

  class Options
    # Create options
    attr_accessor :quiet, :input, :output, :inplace, :dryrun

    # Initialize options
    def initialize
      self.quiet = false
      self.input = nil
      self.output = nil
      self.inplace = nil
      self.dryrun = nil
    end

    def define_options(parser)
      # Help text
      parser.banner = "Usage: ruby control_freak.rb [options]"

      # Other options
      quiet_mode_option(parser)
      input_file_option(parser)
      output_file_option(parser)
      inplace_mode_option(parser)
      dry_run_mode_option(parser)

      parser.on("-h", "--help", "This script removes control characters from files") do
        puts parser
      end

      parser.on("-v", "--version", "Show version") do
        puts Version
        exit
      end
    end

    def quiet_mode_option(parser)
      parser.on("-q", "--quiet", "Suppresses removed character output to the terminal") do
        self.quiet = true
      end
    end

    def input_file_option(parser)
      parser.on("-f", "--file INPUT", "The full or relative path of the file to operate on") do |file|
        self.input = file
      end
    end

    def output_file_option(parser)
      parser.on("-o", "--output OUTPUT", "The full or relative path of the output file") do |out|
        self.output = out
      end
    end

    def inplace_mode_option(parser)
      parser.on("-i", "--in-place", "Writes the changes to the file, in place *(Not working at the moment)*") do
        self.inplace = true
      end
    end

    def dry_run_mode_option(parser)
      parser.on("-d", "--dry-run", "Run a dry run of the characters to be deleted") do
        self.dryrun = true
      end
    end
  end

  # Create a structure that describes the options
  def parse(args)
    @options = Options.new
    @args = OptionParser.new do |parser|
      @options.define_options(parser)
      parser.parse!(args)
    end
    @options
  rescue OptionParser::MissingArgument
    puts "Error: You're missing an argument!"
    exit
  end

  attr_reader :parser, :options
end

class Cleaner
  attr_accessor :options, :clean_file

  def initialize(options)
    @input = options.input
    @quiet = options.quiet
    @output = options.output
    @inplace = options.inplace
    @dryrun = options.dryrun
    self.clean_file = nil
  end

  def input_file
    if @dryrun || @output
      File.open("#{@input}", "r:utf-8")
    elsif @inplace
      File.open("#{@input}", "r+:utf-8")
    end
  end

  def strip_control_characters
    str = ''
    # Iterates through lines of the input file
    input_file.each_line.with_index(1) do |line, line_index|
      # Finds escaped Unicode codepoints and interprets them as a single character
      line = line.gsub(/\\u([0-9A-F]{4})/i){$1.hex.chr(Encoding::UTF_8)}
      # Iterates through characters
      line.each_char.with_index(1) do |char, char_index|
        # Finds ASCII characters 0-31 and 127 (ordinal), except:
        # 9 (horizontal tab, \t)
        # 10 (line feed, \n)
        # 13 (carriage return, \r)
        if char.ascii_only? and (char.ord < 32 or char.ord == 127 and char.ord != 9 and char.ord != 10 and char.ord != 13)
          # Puts line and character number to STDOUT if removed,
          # unless -q flag is present
          $stdout.puts "Line #{line_index}, character #{char_index}:" "\\u%.4x" % char.ord unless @quiet == true
        else
         str << char
        end
      end
    end
  end

  def write_to_new_file
    File.open(@output, "w"){ |f| f.write(strip_control_characters) }
  end

  def write_in_place
    File.open(@input, "r+"){ |f| f.write(strip_control_characters) }
  end

  def write_to_dry_run
    strip_control_characters
  end
end

# Create the option hash for the given argument
op = OptParse.new
options = op.parse(ARGV)
clean = Cleaner.new(options)

# Exits if no input file given
if options.input.nil? && (options.output || options.inplace || options.dryrun || options.quiet)
  puts "Please include an input file (-f, --file)"
  exit
# Exits if no output option given
elsif options.output.nil? && options.inplace.nil? && options.dryrun.nil? && options.input
  puts "You must include one of the following options: output file (-o), in-place (-i), dry run (-d)"
  exit
# Exits if multiple output options given
elsif [options.output, options.inplace, options.dryrun].compact.length > 1
  puts "You cannot include more than one of the following options: output file (-o), in-place (-i), dry run (-d)"
  exit
# Exits if dry run and quiet options given
elsif options.quiet && options.dryrun
  puts "Think about what you're doing."
  exit
elsif options.output
  clean.write_to_new_file
elsif options.inplace
  clean.write_in_place
elsif options.dryrun
  clean.write_to_dry_run
end


