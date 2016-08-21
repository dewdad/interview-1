require_relative './main'

RSpec.describe SidewalkSort do
  before(:each) do
    @sorter = SidewalkSort.new
  end
  #context 'end-to-end' do
  #end
  #

  context '#parse_file' do
    it 'parses the numeric portion' do
      new_array = @sorter.parse_file([
        '10 apples',
        '2 bananas'
      ])

      puts(new_array)

      expect(new_array[0][:numeric_part]).to eq(10)
      expect(new_array[1][:numeric_part]).to eq(2)
    end
  end

#  context '#sort_file' do
#  end

#  context '#write_file' do
#  end
end
