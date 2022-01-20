module PlayersHelper

  def get_trend(totals)
    trend = 0.0
    return trend if totals.blank?
    cnt =  totals.size
    if cnt > 2
      half = cnt / 2
      first_half = totals[0..half]
      last_half = totals[(half+1)..(cnt-1)]
      trend = (first_half.sum / first_half.size.to_f) - (last_half.sum / last_half.size.to_f)
    end
    trend.round(2)
  end

end
