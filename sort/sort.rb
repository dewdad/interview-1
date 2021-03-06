class SidewalkSort
  def do_work(input_file_name, output_file_name)
    contents = File.new(input_file_name, 'r')

    parsed_array = parse_file(contents)
    # sort_file actually modifies parsed_array, so no need to get return val
    sort_file(parsed_array)
    write_file(parsed_array, output_file_name)

    contents.close()
  end

  def parse_file(contents)
    parsed_array = []

    # First task is to split the line into a "numeric" part and a "string" part
    contents.each do |line|
      ########
      # Magic goes here:
      # - allow any number of prefixed spaces/tabs/etc
      # - then expect a number:
      #   - allow negative
      #   - allow floats
      # - then expect a string
      #   - for comparison purposes, we ignore any spaces/tabs or newlines in the "string"
      #     - so, "10Apples" == "10 Apples   "
      num_part = line[/\A[\s]*-?\d*\.{0,1}\d+/]

      string_part = line.strip # if there was no match, then the string is the entire line

      unless num_part.nil?
        # grab the string part before converting the num part
        idx = num_part.length
        string_part = line[idx..line.length].strip

        num_part = num_part.to_f
      end

      parsed_array.push({
        numeric_part: num_part,
        string_part: string_part,
        original_line: line # we need this to write out the original lines
      })
    end

    parsed_array
  end

  def sort_file(parsed_array)
    parsed_array.sort! do |a, b|
      if a[:numeric_part].nil? && b[:numeric_part].nil? # both lacking numbers
        a[:string_part] <=> b[:string_part]
      elsif a[:numeric_part].nil? # whichever is lacking a number goes last
        1
      elsif b[:numeric_part].nil?
        -1
      else
        numeric_diff = a[:numeric_part] <=> b[:numeric_part]

        if numeric_diff == 0
          a[:string_part] <=> b[:string_part]
        else
          numeric_diff
        end
      end
    end
  end

  def write_file(parsed_array, output_file_name)
    output_file = File.new(output_file_name, 'w')
    parsed_array.each do |row|
      output_file.write(row[:original_line])
    end
    output_file.close()
  end
end
