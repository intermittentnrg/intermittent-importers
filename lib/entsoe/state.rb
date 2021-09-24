class ENTSOE::State
  def initialize path
    @path = path
    @state = YAML.load(File.read(@path)) rescue {}
    @state.default = ENTSOE::DEFAULT_START
  end
  def [] key
    @state[key]
  end
  def []= key, value
    @state[key] = value
  end
  def save!
    File.write @path, @state.to_yaml
  end
end
