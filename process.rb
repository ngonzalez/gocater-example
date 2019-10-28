require 'plist'
require 'progress_bar'

class InvalidParameters < StandardError ; end
class InvalidFile < StandardError ; end
class ProcessingError < StandardError ; end

##
# Process data to valid plist XML
# Usage: bundle exec ruby process.rb 'data/test-data-10-exp-5.list' 'data/test-data.plist'
#

source = ARGV[0] ; destination = ARGV[1]
raise InvalidParameters.new('Invalid source file') if source.nil?
raise InvalidParameters.new('Invalid destination file') if destination.nil?

# Open source file
f = File.read source rescue raise InvalidFile.new('Invalid input file')

begin
  # Init progress bar
  count = File.foreach(source).count
  bar = ProgressBar.new count

  result = [] ; item = [] ; values = []
  res = f.strip.split(/\n/).each do |line|
    bar.increment!

    if line =~ /^ / # line starts with empty space, value detected
      values << line.strip
    else
      # add item to result array
      item += values if !values.empty?
      result << item if !item.empty?
      item = [] ; values = [] # new name, reset item and values

      # parse name
      full_name = line.split('--')[0].strip
      last_name = full_name.split(',')[0].strip
      first_name = full_name.split(',')[1].strip

      item << { full_name: full_name, last_name: last_name, first_name: first_name  }
    end
  end
rescue => _exception
  raise ProcessingError.new('Processing Error')
end

puts "Writing XML data to destination file, please wait…"
File.write destination, result.to_plist
puts "Done."
