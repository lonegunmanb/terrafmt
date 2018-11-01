#!/usr/bin/ruby
#take code/markdown as input on stdin, pull out tf blocks, format it with `terraform fmt` and insert pretty tf back in

require 'thor'
require 'colorize'
require 'open3'

#load class that does all the work
require_relative 'blkfmt.rb'

#define the program
class TerraFmtBlocks < Thor

  desc "fmt FILE", "format blocks of terraform found in FILE"
  long_desc <<-LONGDESC
  `terrafmt-blocks |fmt| |FILE|` will format blocks of terraform found in FILE or stdin if no file is specified
  LONGDESC

  option :stdin, type: :boolean, aliases: 'i'
  def fmt(file=nil)
    BlkFmt.new(:fmt, file).go
  end

  desc "diff FILE", "will show a diff of what will be changed in the file"
  def count(file=nil)
    BlkFmt.new(:diff, file).go
  end

  desc "count", "counts the number of blocks # and those generating a diff"
  option :quiet, type: :boolean, aliases: 'q'
  def count(file=nil)
    BlkCount.new(:count, options[:quiet], file).go
  end

  default_task :fmt
end

#run the program
TerraFmtBlocks.start(ARGV)
