require "minitest/autorun"
require_relative "solution"

class SolutionTestPartA < Minitest::Test
  # Sample input data for testing (using heredoc)
  SAMPLE_INPUT = <<~INPUT
    line 1
    line 2
    line 3
  INPUT

  def setup
    @solver = Solution.new(SAMPLE_INPUT)
  end

  # Tests with part1 / partA (and part2 / partB) will only run with that option
  # Tests with no tag will only run with all.
  def test_part1_solution
    # Replace with the expected answer for your sample input
    expected = "Not implemented yet"
    assert_equal expected, @solver.part2
  end

  def test_part2_solution
    # Replace with the expected answer for your sample input
    expected = "Not implemented yet"
    assert_equal expected, @solver.part2
  end
end