require 'yaml'

class BotConfig < Hash
  def initialize
    super
    path = File.join(File.dirname(__FILE__), 'config.yml')
    file = File.read(path)
    config = YAML.load(file)
    self.merge!(config)
  end
end