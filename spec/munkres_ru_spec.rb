require 'spec_helper'

describe MunkresRu do
  it 'has a version number' do
    expect(MunkresRu::VERSION).not_to be nil
  end

  def compute_cost(problem, solution)
    solution.reduce(0) do |sum, (row, col)|
      sum + problem[row][col]
    end
  end

  specify do
    problem = [
      [1.0, 1.0, 1.0, 1.0, 1.0],
      [1.0, 1.0, 1.0, 1.0, 1.0],
      [1.0, 1.0, 1.0, 1.0, 1.0],
      [0.0, 0.0, 0.0, 0.0, 0.0],
      [0.0, 0.0, 0.0, 0.0, 0.0]
    ]
    solution = MunkresRu.solve(problem)
    expect(compute_cost(problem, solution)).to eq(3.0)
  end

  specify do
    problem = [
       [612, 643, 717,   2, 946, 534, 242, 235, 376, 839],
       [224, 141, 799, 180, 386, 745, 592, 822, 421,  42],
       [241, 369, 831,  67, 258, 549, 615, 529, 458, 524],
       [231, 649, 287, 910,  12, 820,  31,  92, 217, 555],
       [912,  81, 568, 241, 292, 653, 417, 652, 630, 788],
       [ 32, 822, 788, 166, 122, 690, 304, 568, 449, 214],
       [441, 469, 584, 633, 213, 414, 498, 500, 317, 391],
       [798, 581, 183, 420,  16, 748,  35, 516, 639, 356],
       [351, 921,  67,  33, 592, 775, 780, 335, 464, 788],
       [771, 455, 950,  25,  22, 576, 969, 122,  86,  74]
    ]
    solution = MunkresRu.solve(problem)
    expect(compute_cost(problem, solution)).to eq(1071)
    expected = [
      [0, 7], [1, 9], [2, 3], [3, 4], [4, 1], [5, 0], [6, 5], [7, 6], [8, 2], [9, 8]
    ]
    expect(solution).to match_array(expected)
  end

  it 'handles infinity' do
    problem = [
      [Float::INFINITY, 1.0, 1.0, 1.0, 1.0],
      [1.0, Float::INFINITY, 1.0, 1.0, 1.0],
      [1.0, 1.0, Float::INFINITY, 1.0, 1.0],
      [0.0, 0.0, 0.0, Float::INFINITY, 0.0],
      [0.0, 0.0, 0.0, 0.0, Float::INFINITY]
    ]
    solution = MunkresRu.solve(problem)
    expect(compute_cost(problem, solution)).to eq(3.0)
  end

  it 'raises exception on NaN' do
    problem = [
      [Float::NAN, 1.0, 1.0, 1.0, 1.0],
      [1.0, Float::NAN, 1.0, 1.0, 1.0],
      [1.0, 1.0, Float::NAN, 1.0, 1.0],
      [0.0, 0.0, 0.0, Float::INFINITY, 0.0],
      [0.0, 0.0, 0.0, 0.0, Float::INFINITY]
    ]
    expect {
      MunkresRu.solve(problem)
    }.to raise_error('Solving Munkres problem failed, check input is valid')
  end
end
