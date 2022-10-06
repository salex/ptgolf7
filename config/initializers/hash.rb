# /config/initializers/hash.rb

class Hash
  def to_o
    JSON.parse to_json, object_class: OpenStruct
  end
end

class String
  def to_b
    return true   if self == true   || self =~ (/(true|t|yes|y|1)$/i)
    return false  if self == false  || self.blank? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end
