module PostsHelper
  def hash_to_struct(a_hash)
    Hash.class_eval do
      def to_struct
        Struct.new(*keys.map(&:to_sym)).new(*values)
      end
    end

    # .to_struct is a monkey_patch to hash in config/initializer
    # don't really need this unless nested hash
    def add_hash_to_struct(struct,member)
     struct[member] = hash_to_struct(struct[member])
    end

    struct = a_hash.to_struct
    struct.members.each do |m|
     add_hash_to_struct(struct,m) if struct[m].is_a? Hash
    end
    struct 
  end

end
