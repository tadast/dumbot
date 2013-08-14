require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/tasker'

class TestTasker < MiniTest::Test

  def setup
    wipe_tasks
    @tasker = Tasker.instance
  end

  def teardown
    wipe_tasks
  end

  def test_push_displays_creator
    @tasker.push('Write better tests', 'DG')
    assert_equal @tasker.all_tasks, '1. Write better tests [DG] (unclaimed)'
  end

private
  def wipe_tasks
    system("echo '' > #{File.join(File.dirname(__FILE__), '..', 'tasks.yaml')}")
  end
end
