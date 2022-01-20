module GroupsHelper


  def get_col_mapping(cnt,columns)
    col_size = get_col_size(cnt,columns)
    all_cnts = (0..(cnt-1)).to_a  # 0.upto(cnt-1).map{|i| i}
    mapping = []
    columns.times do |c|
      mapping << all_cnts.shift(col_size)
    end
    mapping
  end
  def get_col_size(cnt,columns)
    return 1 if cnt.zero?
    col_size = cnt / columns
    col_size += 1 unless cnt % columns == 0
    return col_size
  end

  def col_mapping(cnt,columns)
    dm_arr = cnt.divmod(columns)
    idxs = (0..(cnt-1)).to_a
    col_map = []
    columns.times do |i| 
      extr = dm_arr[1] > 0 ? 1 : 0
      col_map << idxs.shift(dm_arr[0] + extr)
      dm_arr[1] -= 1 if dm_arr[1] > 0
    end
    col_map
  end

  def col_map_array(ary,columns)
    col_size,mod_size = ary.size.divmod(columns)
    map = []
    columns.times do |c|
      rem = mod_size.zero? ? 0 : 1
      map << ary.shift(col_size + rem)
      mod_size -= 1 if !mod_size.zero?
    end
    map
  end

  def col_map_index(cnt,columns)
    ary = (0..(cnt-1)).to_a
    col_map_array(ary,columns)
  end


end
