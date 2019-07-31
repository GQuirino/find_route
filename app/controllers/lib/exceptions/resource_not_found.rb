class ResourceNotFound < StandardError
  attr_accessor :resource
  def initialize(resource)
    @resource = resource
  end
end
