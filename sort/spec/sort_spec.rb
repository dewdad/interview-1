require_relative '../sort'
require 'digest/md5'

RSpec.configure do |config|
  config.formatter = :documentation
end

RSpec.describe SidewalkSort do
  before(:each) do
    @sorter = SidewalkSort.new
  end

  context 'end-to-end' do
    before(:all) do
      @test_output = './spec/test_output.txt'
      @known_test_input = './spec/test_input_case_1.txt'
      @known_test_output = './spec/test_output_case_1.txt'

      # If somehow the last run left behind artifacts, delete
      File.delete(@test_output) if File.exist?(@test_output)
    end

    it 'correctly reads and writes to files' do
      # somewhat redundant sanity check in case the before and after hooks fail,
      # also, in case of concurrency issues on CI server with multithreading/jobs/runs
      expect(File).not_to exist(@test_output)

      @sorter.do_work(@known_test_input, @test_output)

      expect(File).to exist(@test_output)

      known_hash = Digest::MD5.hexdigest(File.read(@known_test_output))
      new_hash = Digest::MD5.hexdigest(File.read(@test_output))
      expect(new_hash).to eq(known_hash)
    end

    after(:all) do
      # Make sure everything gets cleaned up no matter what
      File.delete(@test_output)
    end
  end

  context '#parse_file' do
    let(:test_input) do
      [
        '10 apples',
        '2 bananas'
      ]
    end

    it 'saves the original line' do
      new_array = @sorter.parse_file(test_input)
      expect(new_array.length).to eq(2)

      new_array.each_with_index do |row, idx|
        expect(row.length).to eq(3)
        expect(row[:original_line]).to eq(test_input[idx])
      end
    end

    context 'string part' do
      it 'parses the string portion' do
        new_array = @sorter.parse_file(test_input)
        expect(new_array[0][:string_part]).to eq('apples')
        expect(new_array[1][:string_part]).to eq('bananas')
      end

      it 'handles missing numbers' do
        new_array = @sorter.parse_file([
          'apples',
          ' bananas' # check to see if it handles the empty space correctly
        ])
        expect(new_array[0][:string_part]).to eq('apples')
        expect(new_array[1][:string_part]).to eq('bananas')
      end

      it 'white space shenangians' do
        new_array = @sorter.parse_file([
          'apples',
          '     bananas', # handle leading spaces
          'cookies     ', # handle trailing spaces
          '  dumplings ', # both leading and trailing
          ' eggs & ham '  # all the spaces
        ])
        expect(new_array[0][:string_part]).to eq('apples')
        expect(new_array[1][:string_part]).to eq('bananas')
        expect(new_array[2][:string_part]).to eq('cookies')
        expect(new_array[3][:string_part]).to eq('dumplings')
        expect(new_array[4][:string_part]).to eq('eggs & ham')
      end

      it 'ignores numeric digits in the string' do
        new_array = @sorter.parse_file([
          '9 c4tliv3s',
          '9c4tliv3s', # isn't confused by the lack of space
          'c4tliv3s'
        ])

        expect(new_array[0][:string_part]).to eq('c4tliv3s')
        expect(new_array[1][:string_part]).to eq('c4tliv3s')
        expect(new_array[2][:string_part]).to eq('c4tliv3s')
      end

      it 'parses a blank line into a string rather than nil' do
        new_array = @sorter.parse_file([
          '',
          '1 apple'
        ])

        expect(new_array[0][:string_part]).to eq('')
        expect(new_array[1][:string_part]).to eq('apple')
      end

      it 'parses independent of numeric edge cases' do
        new_array = @sorter.parse_file([
          '-4 apples',
          ' 50.1 bananas' # handle leading space
        ])
        expect(new_array[0][:string_part]).to eq('apples')
        expect(new_array[1][:string_part]).to eq('bananas')
      end

      it 'parses non-alpha characters' do
        new_array = @sorter.parse_file([
          '15 !@#$%^&*()',
        ])

        expect(new_array[0][:string_part]).to eq('!@#$%^&*()')
      end
    end

    context 'numeric part' do
      it 'parses the numeric portion' do
        new_array = @sorter.parse_file(test_input)
        expect(new_array[0][:numeric_part]).to eq(10)
        expect(new_array[1][:numeric_part]).to eq(2)
      end

      it 'defaults the number to nil if missing' do
        new_array = @sorter.parse_file([
          'apples',
          ' bananas' # check to see if it handles the empty space correctly
        ])
        expect(new_array[0][:numeric_part]).to eq(nil)
        expect(new_array[1][:numeric_part]).to eq(nil)
      end

      it 'handles negative numbers' do
        new_array = @sorter.parse_file([
          '-42 apples',
          ' -5 bananas', # handle leading spaces
          '-3.6 cookies' # negative floats
        ])
        expect(new_array[0][:numeric_part]).to eq(-42)
        expect(new_array[1][:numeric_part]).to eq(-5)
        expect(new_array[2][:numeric_part]).to eq(-3.6)
      end

      it 'handles floats' do
        new_array = @sorter.parse_file([
          '4.2 apples',
          ' 50.1 bananas' # handle leading space
        ])
        expect(new_array[0][:numeric_part]).to eq(4.2)
        expect(new_array[1][:numeric_part]).to eq(50.1)
      end

      it 'works even if no string part' do
        new_array = @sorter.parse_file([
          '42'
        ])
        expect(new_array[0][:numeric_part]).to eq(42)
      end
    end
  end

  context '#sort_file' do
    it 'base case' do
      test_array = [
        {numeric_part: 10, string_part: 'apples'},
        {numeric_part: 2, string_part: 'apples'},
      ]
      @sorter.sort_file(test_array)
      expect(test_array).to eq([
        {numeric_part: 2, string_part: 'apples'},
        {numeric_part: 10, string_part: 'apples'},
      ])
    end

    context 'string part' do
      it 'sorts by string when numbers match' do
        test_array = [
          {numeric_part: 1, string_part: 'bananas'},
          {numeric_part: 1, string_part: 'apples'}
        ]
        @sorter.sort_file(test_array)
        expect(test_array).to eq([
          {numeric_part: 1, string_part: 'apples'},
          {numeric_part: 1, string_part: 'bananas'}
        ])
      end

      it 'sorts by string when numbers are missing' do
        test_array = [
          {numeric_part: nil, string_part: 'bananas'},
          {numeric_part: nil, string_part: 'apples'}
        ]
        @sorter.sort_file(test_array)
        expect(test_array).to eq([
          {numeric_part: nil, string_part: 'apples'},
          {numeric_part: nil, string_part: 'bananas'}
        ])
      end

      it 'empty string goes before anything else' do
        test_array = [
          {numeric_part: nil, string_part: 'A'},
          {numeric_part: nil, string_part: ''}
        ]
        @sorter.sort_file(test_array)
        expect(test_array).to eq([
          {numeric_part: nil, string_part: ''},
          {numeric_part: nil, string_part: 'A'}
        ])
      end

      it 'follows ascii table for string sorting' do
        test_array = [
          {numeric_part: nil, string_part: 'A'},
          {numeric_part: nil, string_part: '^'},
          {numeric_part: nil, string_part: '<'},
          {numeric_part: nil, string_part: 'a'},
          {numeric_part: nil, string_part: '~'},
          {numeric_part: nil, string_part: '}'},
          {numeric_part: nil, string_part: '_'},
          {numeric_part: nil, string_part: '#'}
        ]
        @sorter.sort_file(test_array)
        expect(test_array).to eq([
          # some symbols are before alpha:  !"#$%&`()*+,-./:;<=>?@
          {numeric_part: nil, string_part: '#'},
          {numeric_part: nil, string_part: '<'},

          {numeric_part: nil, string_part: 'A'},

          # some are between upper and lower:  []\^_`
          {numeric_part: nil, string_part: '^'},
          {numeric_part: nil, string_part: '_'},

          {numeric_part: nil, string_part: 'a'},

          # some symobls are after alpha:  {}|~
          {numeric_part: nil, string_part: '}'},
          {numeric_part: nil, string_part: '~'}
        ])
      end
    end

    context 'numeric part' do
      it 'precedence to numbers over nil' do
        test_array = [
          {numeric_part: nil, string_part: 'bananas'},
          {numeric_part: 1, string_part: 'apples'}
        ]
        @sorter.sort_file(test_array)
        expect(test_array).to eq([
          {numeric_part: 1, string_part: 'apples'},
          {numeric_part: nil, string_part: 'bananas'}
        ])
      end

      it 'sorts all kinds of numbers' do
        test_array = [
          {numeric_part: 10, string_part: 'apples'},
          {numeric_part: -22, string_part: 'apples'},
          {numeric_part: 3.14, string_part: 'apples'},
          {numeric_part: 9000, string_part: 'apples'}

        ]
        @sorter.sort_file(test_array)
        expect(test_array).to eq([
          {numeric_part: -22, string_part: 'apples'},
          {numeric_part: 3.14, string_part: 'apples'},
          {numeric_part: 10, string_part: 'apples'},
          {numeric_part: 9000, string_part: 'apples'}
        ])
      end

      it 'sorts by numeric order rather than alpha order' do
        test_array = [
          {numeric_part: 90, string_part: 'apples'},
          {numeric_part: 100, string_part: 'apples'},
          {numeric_part: 5, string_part: 'apples'}

        ]
        @sorter.sort_file(test_array)
        expect(test_array).to eq([
          {numeric_part: 5, string_part: 'apples'},
          {numeric_part: 90, string_part: 'apples'},
          {numeric_part: 100, string_part: 'apples'}
        ])
      end
    end
  end
end
