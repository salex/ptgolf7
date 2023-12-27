module GamesHelper
  def to_nickels(num,str=false)
    dollars = num.to_i
    cents = (num - dollars + 0.001).round(2) # can have float inaccracy
    nickels  = dollars + (cents * 20).floor * 0.05
    if str
      return format("%.2f", nickels)
    else
      return nickels
    end
  end

  def to_dimes(num,str=false)
    dollars = num.to_i
    cents = (num - dollars + 0.001).round(2) # can have float inaccracy
    dimes  = dollars + (cents * 10).floor * 0.1
    if str
      return format("%.2f", dimes)
    else
      return dimes
    end
  end

  def to_qtr(num)
    amt = ((num * 4).to_i / 0.25 / 4) * 0.25
  end

  def to_quarters(num,str=false)
    dollars = num.to_i
    cents = (num - dollars + 0.001).round(2) # can have float inaccracy
    quarters  = dollars + (cents * 4).floor * 0.25
    if str
      return format("%.2f", quarters)
    else
      return quarters
    end
  end

  def tee_options(group,player,letter=false)
    tees = group.tees.split
    options = []
    curr_tee = "#{player.id}.#{player.tee}.#{player.tee}"
    tees.each do |t|
      tvalue = "#{player.id}.#{player.tee}.#{t}"
      disp = letter ? t[0..0] : t
      options << [disp,tvalue]
    end
    options_for_select(options,:selected => curr_tee)
  end

  def tee_select_options(arr,sel)
    coll = []
    arr.each{|t| coll << [t,t]}
    options_for_select(coll,sel)
  end
  
  def get_base(min,max,prompt='Select')
    base = (-min.to_i..0).to_a + [prompt] + (0..max.to_i).to_a
  end

  def pulled_options_side(quota,max=10.0)
    max = max.to_f
    max = [max,10.0].min
    squota = quota / 2.0
    step = squota - squota.to_i
    min = max > squota ? squota + step : max
    base = get_base(min,max)
    opt = []
    base.each do |p|
      if p == 'Select'
        opt << [p,p]
      else
        opt << ["#{(p+squota+step).to_i} (#{p+step})", (p+squota+step).to_i]
      end
    end
    opt
  end

  def pulled_options_total(quota,max=21)
    min = max > quota ? quota : max
    base = get_base(min,max,'')
    opt = []
    base.each do |p|
      if p == '' || p == 'Select' || p == 'Unscored'
        opt << ['Unscored','Unscored']
      else
        opt << ["#{p+quota} (#{p})", p+quota]
      end
    end
    opt
  end

  def pulled_options(quota,max=21)
     {side: pulled_options_side(quota,max.to_f),total: pulled_options_total(quota,max)}
  end

  def pulledx_crap_wrote(side,side_net,quota,limit)
    if limit.present?
      lim = limit.to_i
      pm = side - quota
      if pm.abs > lim
        pp = side.to_s
        pp << ' ['

        if pm.positive?
          lim = lim * -1
        end
        pp << (quota - lim).to_s
        pp << '('
        pp << (lim * -1).to_s
        pp << ')]'
      else
        pp =  side.to_s
        pp << ' ['
        pp << pm.to_s
        pp << ']'
      end
    else
      pm = side - quota
      pp = side.to_s
      pp << ' ('
      pp << pm.to_s
      pp << ')'
    end
    pp

  end

  def pulled(side,side_net,quota,limit)
    # side_net not used, don't know why (want to show decimal was why)
    pm = side - quota 
    if limit.present?
      lim = limit.to_i
      if pm.abs > lim
        lim = (lim * -1) if pm.positive?
        pp = "#{side} [#{quota - lim}(#{lim * -1})]"
      else
        pp = "#{side} [#{pm}]"
      end
    else
      pp = "#{side} (#{pm})"
    end
    pp
  end
end
