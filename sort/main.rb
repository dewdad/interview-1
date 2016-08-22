require_relative './sort'

puts 'Running!'
sorter = SidewalkSort.new
sorter.do_work('spec/test_input.txt', 'test_output.txt')

# For debugging and nice output
output_contents = File.new('test_output.txt', 'r')
LIMIT = 5
output_contents.each_with_index do |row, idx|
  break if idx > LIMIT
  puts row
end
