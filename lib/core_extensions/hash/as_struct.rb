# /lib/core_extensins/as_struct.rb
# convert Hash to a nested Struct 
module CoreExtensions
  module Hash
    def as_struct
      hash_as_struct(self)
    end

    private

    def hash_as_struct(ahash)
      struct = ahash.to_struct # convert to struct first level
      struct.members.each do |m|
        if struct[m].is_a? Hash
          struct[m] = hash_as_struct(struct[m]) # nested hash, recursive call
        elsif struct[m].is_a? Array 
          # look for hashes in an array and convert to struct
          struct[m].each_index do |i|
            # normal use, an array of hashes
            struct[m][i] = hash_as_struct(struct[m][i]) if struct[m][i].is_a? Hash
            # convoluded use, an array that may contain hash(es)
            struct[m][i] = hash_in_array(struct[m][i]) if struct[m][i].is_a? Array
          end
        end
      end
      struct 
    end

    def hash_in_array(arr)
      arr.each_index do |ii|
        arr[ii] = hash_as_struct(arr[ii]) if arr[ii].is_a? Hash 
      end
      arr
    end 
  end
end




# h = {
#   game:{id:1,date:'2022-09-11',player:6},
#   players:[{name:'Joe',quota:21},{name:'Harry',quota:26},{name:'Pete',quota:14},
#     {name:'don',quota:21},{name:'sally',quota:26},{name:'red',quota:14}],
#   teams:{one:['joe','don',team:{a:1,b:2,c:3}],two:['harry','sally'],three:['pete','red']}}

# h = {
#   game:{id:1,date:'2022-09-11',player:6},
#   players:[{name:'Joe',quota:21},{name:'Harry',quota:26},{name:'Pete',quota:14},
#     {name:'don',quota:21},{name:'sally',quota:26},{name:'red',quota:14}],
#   teams:[['joe','don',team:{a:1,b:2,c:3}],['harry','sally',lost:{skins:2,par3:9}],['pete','red']]}

