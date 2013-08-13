require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/tasker'

class TestTasker < MiniTest::Test

  def setup
    @tasker = Tasker.instance
  end

  def test_push_displays_creator
    @tasker.push('Write better tests', 'DG')
    assert_equal @tasker.all_tasks, '1. Write better tests [DG] (unclaimed)'
  end

end
