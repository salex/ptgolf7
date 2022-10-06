# /lib/core_extensins/to_struct.rb
# convert Hash to Struct on a single level
module CoreExtensions
  module Hash
    def to_struct
      Struct.new(*keys.map(&:to_sym)).new(*values)
    end
  end
end
