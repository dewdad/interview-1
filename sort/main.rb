require_relative './sort'

puts "Running Sidewalk Sorter on file: #{ARGV[0]}!"
output_file = 'test_output.txt'
sorter = SidewalkSort.new
sorter.do_work(ARGV[0], output_file)

puts "Sort complete! Output written to: #{output_file}"
puts
puts "Here's a sample of the first few (sorted) lines:"

# For debugging and nice output
output_contents = File.new(output_file, 'r')
LIMIT = 5
output_contents.each_with_index do |row, idx|
  break if idx > LIMIT
  puts row
end
