require 'spec_helper'

describe MunkresRu do
  it 'has a version number' do
    expect(MunkresRu::VERSION).not_to be nil
  end

  it 'solves a problem' do
    array = [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]
    res = MunkresRu.solve(array)
    expect(res).to be_a(Hash)
    puts res.inspect
  end
end
