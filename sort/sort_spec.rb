require_relative './main'

RSpec.describe SidewalkSort do
  before(:each) do
    @sorter = SidewalkSort.new
  end
  #context 'end-to-end' do
  #end
  #

  context '#parse_file' do
    let(:test_input) do
      [
        '10 apples',
        '2 bananas'
      ]
    end

    it 'parses the numeric portion' do
      new_array = @sorter.parse_file(test_input)
      expect(new_array[0][:numeric_part]).to eq(10)
      expect(new_array[1][:numeric_part]).to eq(2)
    end

    it 'parses the string portion' do
      new_array = @sorter.parse_file(test_input)
      expect(new_array[0][:string_part]).to eq('apples')
      expect(new_array[1][:string_part]).to eq('bananas')
    end

    it 'defaults the number to nil if missing' do
      new_array = @sorter.parse_file([
        'apples',
        ' bananas' # check to see if it handles the empty space correctly
      ])
      expect(new_array[0][:numeric_part]).to eq(nil)
      expect(new_array[1][:numeric_part]).to eq(nil)
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

    it 'ignores numeric digits in the string' do
      new_array = @sorter.parse_file([
        '9 c4tliv3s',
        '9c4tliv3s' # isn't confused by the lack of space
      ])

      expect(new_array[0][:string_part]).to eq('c4tliv3s')
      expect(new_array[1][:string_part]).to eq('c4tliv3s')
    end
  end

#  context '#write_file' do
#  end
end
