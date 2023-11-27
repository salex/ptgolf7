module Things
  class PgaPlaces
    attr_accessor :winners, :pot, :perc
    include Things::Utilities

    # pga current payouts
    # https://www.easyofficepools.com/pga-tour-payout-percentages-and-projected-earnings/
    def initialize(numb_players,dues,dist=nil,perc=nil)
      dues = dues.to_f
      @pot = numb_players * dues 
      if perc.present?
        places_paid = (perc.to_f/100 * numb_players).to_i 
      else
        places_paid = numb_players / 2
      end

      # current pga tournement payout percentes for up to 40 players, we'll never use more that 12!
      pga_perc = [18.000,10.900,6.900,4.900,4.100,3.625,3.375,3.125,2.925,2.725,
        2.525,2.325,2.125,1.925,1.825,1.725,1.625,1.525,1.425,1.325,1.225,1.125,
        1.045,0.965,0.885,0.805,0.775,0.745,0.715,0.685,0.655]
      # pga_perc = [16.000,12.000,9.000,7.000,6.000,5.000,4.500,4.000,3.500,3.000,2.500,2.000,1.750,1.500,1.250,1.000]
      if dist == 'low'
        percents = pga_perc[2..(places_paid + 1)]
      elsif dist == 'high'
        percents = pga_perc[0..(places_paid - 1)]
      else #mid
        percents = pga_perc[1..(places_paid + 0)]
      end

      sum = percents.sum
      @winners = Array.new(places_paid)

      percents.each_with_index do |v,i|
        percents[i] = v/sum 
      end
      winners.each_with_index do |v,i|
        winners[i] = percents[i] * @pot
      end
      @winners = @winners.reverse
      # Things::Utilities.
      dollarize(@winners,@pot)

    end

  end
end

