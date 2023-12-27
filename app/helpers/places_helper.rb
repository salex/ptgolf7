module PlacesHelper

  def pga_percents(players,dist:nil,perc:nil)
    # players is an integer 2..i less then 2 will return [] places
    # dist 
    #   is a number (0..3)
    #   or string in [high,mid,low,even] default mid
    # perc 
    #   is an interger or float converted to an 
    # expect sane inputs but will compensate

    #puts "players in #{players} dist #{dist}  perc #{perc}"

    # taken from pga_score_places.rb upto 40 places!
    # https://www.easyofficepools.com/pga-tour-payout-percentages-and-projected-earnings/
    pga_perc = [18.000,10.900,6.900,4.900,4.100,3.625,3.375,3.125,2.925,
      2.725,2.525,2.325,2.125,1.925,1.825,1.725,1.625,1.525,1.425,1.325,
      1.225,1.125,1.045,0.965,0.885,0.805,0.775,0.745,0.715,0.685,0.655,
      0.625,0.595,0.570,0.545,0.520,0.495,0.475,0.455,0.435]

    if perc.present?
      pay_places = (perc.to_f/100 * players.to_i).to_i 
    else
      pay_places = players.to_i / 2
    end

    if dist.present?
      if dist.is_a?(String)
        dist.downcase!
        case dist
        when 'high'
          offset = 0 
        when 'low'
         offset = 2 
        when 'even'
          offset = 3
        else
          offset = 1 #mid
        end
      else  
        offset = dist.to_i
      end
    else
      offset = 1 #mid
    end

    #puts "players in #{players} dist #{dist}  perc #{perc} pay_places #{pay_places} offset #{offset}"
    # offset selects a range from the pga_perc array
    percents = pga_perc[offset..(pay_places + (offset - 1))]
    sum = percents.sum
    percents.each_with_index do |v,i|
      percents[i] = (v/sum).round(4) 
    end
    return percents
  end

  def dollarize(winners,pot)
    # dollarize takes an array of floats (winners) and rounds each element
    #   to a whole number (up or down)
    winners.each_with_index{|w,i| winners[i] = winners[i].round.to_f}
    # the pot is a whole number that was equal to the sum of winners
    # now that elements are rounded, the pot may not equal the sum of winners
    if winners.sum != pot
      # get difference if not equal which may be negative or positive 
      diff = (winners.sum - pot).to_i
      # puts "DIFF #{diff}"
      if diff.negative?
        # sum of winners is short, add shortage to low winners
        (diff*-1).times do |i|
          winners[i] += 1
        end
      else
        # sum of winners is over, subtract shortage to high winners
        (diff).times do |i|
          winners[-i - 1] -= 1
        end
      end
      # the sum of the winners is now eqaul to the pot
    end
    # else fall through, rounding did not change the sum
  end

end