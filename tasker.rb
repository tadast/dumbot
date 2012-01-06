require 'singleton'

class Tasker
  include Singleton
  Task = Struct.new(:id, :description, :owner) do
    def to_s
      "#{id}. #{description}"
    end
  end

  def initialize
    @tasks = []
  end

  def push(text, user = nil)
    @tasks << Task.new(next_id, text, user)
  end

  def next_id
    (@tasks.map(&:id).max || 0) + 1
  end

  def all_tasks
    if @tasks.empty?
      "Nothing urgent to do. Back to regular scheduled card work."
    else
      @tasks.map do |task|
        "#{task} (#{task.owner || 'unclaimed'})"
      end.join("\n")
    end
  end

  def my_tasks(user)
    tasks = @tasks.select{|t| t.owner == user}
    if tasks.empty?
      if @tasks.size > 0
        "Nothing assigned to you. Grab one of the #{@tasks.count} other tasks."
      else
        "Nothing urgent to do. Back to regular scheduled card work."
      end
    else
      tasks.map(&:to_s).join("\n")
    end
  end

  def task(id)
    if id && task = @tasks.find { |t| t.id == id.to_i}
      yield task
    else
      "No such task"
    end
  end

  def import(lines)
    lines.strip.split("\n").each do |line|
      left = line.sub(/\d\./, '').strip
      owner = left.reverse.split('(').first.reverse[0..-2]
      push(left.sub("(#{owner})".strip, ''), owner)
    end
  end

  def claim(id, user)
    task(id) do |task|
      task.owner = user
      "#{task} taken by #{user}"
    end
  end

  def assign(id, user)
    task(id) do |task|
      task.owner = user
      "@#{user}, you have been assigned #{task}"
    end
  end

  def give_up(id)
    task(id) do |task|
      task.owner = nil
      "LOL, man-up dude!"
    end
  end

  def me(user)
    @tasks.select { |t| t.owner == user}.join("\n")
  end

  def done(id, user)
    task(id) do |task|
      @tasks.delete(task)
      "Well played #{user}, you completed #{task}"
    end
  end

  def help
    "Commands\n"
    ["all tasks",
     "add task <description>",
     "show my tasks",
     "<id> is mine",
     "<id> is done",
     "<id> is too hard",
     "<user> do <id>",
     "my tasks",
     "task help"].map{ |s| "  #{s}"}.join("\n")
  end
end
