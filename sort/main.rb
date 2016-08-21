class SidewalkSort
  def do_work
    contents = File.new('input.txt', 'r')

    parsed_array = parse_file(contents)
    parsed_array = sort_file(parsed_array)

    write_file(parsed_array)
  end
end
