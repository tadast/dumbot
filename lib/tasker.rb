require 'singleton'

class Tasker
  include Singleton
  Task = Struct.new(:id, :description, :owner) do
    def to_s
      "#{id}. #{description}"
    end
  end

  def initialize
    @tasks = read_tasks
  end

  def task_file
    File.expand_path("../../tasks.yaml", __FILE__)
  end

  def write_tasks
    File.write(task_file, YAML.dump(@tasks))
  end

  def read_tasks
    YAML.load(File.read(task_file))
  rescue => e
    puts "Failed to read tasks.json: #{e.message}"
    return []
  end

  def push(text, user = nil)
    @tasks << Task.new(next_id, text, user)
    write_tasks
  end

  def delete(task)
    @tasks.delete(task)
    write_tasks
  end

  def next_id
    (@tasks.map(&:id).max || 0) + 1
  end

  def all_tasks
    if @tasks.empty?
      nothing_urgent
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
        nothing_urgent
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
      left = line.sub(/\d{1,3}\./, '').strip
      owner = left.reverse.split('(').first.reverse[0..-2]
      push(left.sub("(#{owner})".strip, ''), owner)
    end
  end

  def remove(id)
    task(id) do |task|
      delete(task)
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
      delete(task)
      "Well played #{user}, you completed #{task}"
    end
  end

  def random
    [ "http://1.bp.blogspot.com/_D_Z-D2tzi14/TBpOnhVqyAI/AAAAAAAADFU/8tfM4E_Z4pU/s400/responsibility12(alternate).png",
      "http://2.bp.blogspot.com/_D_Z-D2tzi14/TBpOglLvLgI/AAAAAAAADFM/I7_IUXh6v1I/s400/responsibility10.png",
      "http://4.bp.blogspot.com/_D_Z-D2tzi14/TBpOY-GY8TI/AAAAAAAADFE/eboe6ItMldg/s400/responsibility11.png",
      "http://2.bp.blogspot.com/_D_Z-D2tzi14/TBpOOgiDnVI/AAAAAAAADE8/wLkmIIv-xiY/s400/responsibility13(alternate).png",
      "http://3.bp.blogspot.com/_D_Z-D2tzi14/TBpa3lAAFQI/AAAAAAAADFs/8IVZ-jzQsLU/s400/responsibility14.png",
      "http://3.bp.blogspot.com/_D_Z-D2tzi14/TBpoOlpMa_I/AAAAAAAADGU/CfZVMM9MqsU/s400/responsibility102.png",
      "http://4.bp.blogspot.com/_D_Z-D2tzi14/TBpoVLLDgCI/AAAAAAAADGc/iqux8px_V-s/s400/responsibility12(alternate)2.png",
      "http://2.bp.blogspot.com/_D_Z-D2tzi14/TBpqGvZ7jVI/AAAAAAAADGk/hDTNttRLLks/s400/responsibility8.png"
    ].sample
  end

  def help
    "Commands\n"
    ["all tasks",
     "add task <description>",
     "<id> is mine",
     "<id> is done",
     "<id> is too hard",
     "<user> do <id>",
     "my tasks",
     "task help"].map{ |s| "  #{s}"}.join("\n")
  end
private
  def nothing_urgent
    "Nothing urgent. You can ask for random task though, say 'random task please'"
  end
end
