require 'spec_helper'

describe MunkresRu do
  it 'has a version number' do
    expect(MunkresRu::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(MunkresRu.double_input(2)).to eq(4)
  end
end
