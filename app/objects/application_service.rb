class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end

  def self.get(*args, &block)
    new(*args, &block).get
  end

end
