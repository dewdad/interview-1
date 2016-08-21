class SidewalkSort
  def do_work
    contents = File.new('input.txt', 'r')

    parsed_array = parse_file(contents)
    parsed_array = sort_file(parsed_array)

    write_file(parsed_array)
  end

  def parse_file(contents)
    parsed_array = []

    # First task is to split the line into a "numeric" part and a "string" part
    contents.each do |line|
      num_part = line[/\A[\d]+/]

      # grab the string part before converting the num part
      idx = num_part.length
      string_part = line[idx..line.length].strip

      num_part = num_part.to_f

      parsed_array.push({
        numeric_part: num_part,
        string_part: string_part
      })
    end

    parsed_array
  end

  def sort_file(parsed_array)
    parsed_array.sort! do |a, b|
      numeric_diff = a[:numeric_part] <=> b[:numeric_part]

      if numeric_diff == 0
        a[:string_part] <=> b[:string_part]
      else
        numeric_diff
      end
    end
  end
end
