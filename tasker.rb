require 'singleton'

class Tasker
  include Singleton
  Task = Struct.new(:id, :description, :owner)

  def initialize
    @id = 0
    @tasks = []
  end

  def next_id
    @id += 1
  end

  def push(text)
    @tasks << Task.new(next_id, text, nil)
  end

  def list
    if @tasks.empty?
      "Nothing urgent to do. Back to regular scheduled card work."
    else
      @tasks.map do |task|
        "#{task.id}. #{task.description} (#{task.owner || 'unclaimed'})"
      end.join("\n")
    end
  end

  def task(id)
    if id && task = @tasks.find { |t| t.id == id.to_i}
      yield task
    else
      "No such task"
    end
  end

  def claim(id, user)
    task(id) do |task|
      task.owner = user
      "Ok #{user}, you #{task.description}"
    end
  end

  def done(id, user)
    task(id) do |task|
      @tasks.delete(task)
      "Thanks #{user}, well done."
    end
  end

  def help
    ["push <task description>",
     "list",
     "claim <id>",
     "done <id>"].join("\n")
  end
end