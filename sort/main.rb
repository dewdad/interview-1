require_relative './sort'

puts "##############################"
puts "##############################"
puts "##"
puts "##"
puts "## MYSIDEWALK code submission stuff"
puts "##  (ps the spec tests should be right above if this is the first run^)"
puts "##"
puts "##"
puts "Sorting file: #{ARGV[0]}!"

output_file = 'output/output.txt'
sorter = SidewalkSort.new
sorter.do_work(ARGV[0], output_file)

puts "Sort complete!"
puts "Output written to: #{output_file}"
puts
puts "Here's a sample of the first few (sorted) lines:"

# For debugging and nice output
output_contents = File.new(output_file, 'r')
LIMIT = 5
output_contents.each_with_index do |row, idx|
  break if idx > LIMIT
  puts row
end
