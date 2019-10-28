require 'plist'
require './lib/helpers'
include ExampleHelpers

class InvalidParameters < StandardError ; end

##
# Read example plist file and validate coding exercises
# Usage: bundle exec ruby example 'data/test-data.plist'
#

source = ARGV[0]
raise InvalidParameters.new('Invalid source file') if source.nil?

# Open source file
result = Plist.parse_xml source

# Collect data
full_names = [] ; first_names = [] ; last_names = []
result.each do |item|
  full_names << item[0]["full_name"]
  first_names << item[0]["first_name"]
  last_names << item[0]["last_name"]
end

##
# Question 1
# Print out the number of unique full names, first names and last names
#
puts "----------\nQuestion 1:\n----------"
puts "There are #{full_names.uniq.count} unique full names."
puts "There are #{first_names.uniq.count} unique first names."
puts "There are #{last_names.uniq.count} unique last names."

##
# Question 2
# Print to standard out the 10 most common first names along with the
# number of times the name appeared in the file in descending order.
#
puts "----------\nQuestion 2:\n----------"
result = Hash.new 0
first_names.each { |item| result[item] += 1 }
result.sort_by { |_name, count| count }.reverse.take(10).each do |item|
  puts "#{item[0]} (#{item[1]})"
end

##
# Question 3
# Print to standard out the 10 most common last names along with the
# number of times the name appeared in the file in descending order.
#
puts "----------\nQuestion 3:\n----------"
result = Hash.new 0
last_names.each { |item| result[item] += 1 }
result.sort_by { |_name, count| count }.reverse.take(10).each do |item|
  puts "#{item[0]} (#{item[1]})"
end

##
# Question 4
# A) Identify the first 25 completely unique names in the file.
#
puts "----------\nQuestion 4 A:\n----------"
array_a = []
full_names.each do |item|
  break if array_a.length == 25
  hash = item_hash(item)
  array_a << hash if !check_array(array_a, hash)
end
array_a.each { |item| puts item.values.join(', ') }

# B) Generate 25 new unique combination of names (first and last name) 
# using the names we gathered in the step A (using any method).
# These names must be new and unique and not appear in the original set of 25 names.
#
puts "----------\nQuestion 4 B:\n----------"
array_b = []
full_names.each do |item|
  break if array_b.length == 25
  hash = item_hash(item)
  array_b << hash if !check_array(array_a, hash) &&
    !check_array(array_b, hash)
end
array_b.each { |item| puts item.values.join(', ') }
