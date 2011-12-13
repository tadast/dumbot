require 'yaml'

class BotConfig < Hash
  def initialize
    super
    file = File.read('config.yml')
    config = YAML.load(file)
    self.merge!(config)
  end
end