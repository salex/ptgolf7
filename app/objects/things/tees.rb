module Things
  class Tees

    def initialize
      @classic = %w(Green Red Gold White Blue Black)
      @local = %w(Green Red Gray White Blue Yellow)
      @named = %w(Junior Front Forward Middle Back Pro)
    end

    def classic_to_local(classic_tee)
      classic_idx = @classic.find_index(classic_tee)
      to_tee = @to[classic_idx] if classic_idx.present?
      return to_tee.present? ? to_tee : 'Unknown Classic Tee'
    end

    def local_to_classic(local_tee)
      local_idx = @local.find_index(local_tee)
      classic_tee = @classic[local_idx] if local_idx.present?
      return classic_tee.present? ? classic_tee : 'Unknown Local Tee'
    end

    def named_to_local(named_tee)
      named_idx = @named.find_index(named_tee)
      local_tee = @local[named_idx] if named_idx.present?
      return local_tee.present? ? local_tee : 'Unknown Named Tee'
    end

    def local_to_named(local_tee)
      local_idx = @local.find_index(local_tee)
      named_tee = @named[local_idx] if local_idx.present?
      return named_tee.present? ? named_tee : 'Unknown local Tee'
    end



  end
end
