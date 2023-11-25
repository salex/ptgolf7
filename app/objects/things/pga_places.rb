module Things
  class PgaPlaces
    attr_accessor :winners, :pot, :perc
    include Things::Utilities

    # pga current payouts
    # https://www.easyofficepools.com/pga-tour-payout-percentages-and-projected-earnings/
    def initialize(numb_players,dues,perc=nil)
      dues = dues.to_f
      @pot = numb_players * dues 
      if perc.present?
        places_paid = (perc.to_f/100 * numb_players).to_i 
      else
        places_paid = numb_players / 2
      end
      # current pga tournement payout percentes for up to 40 players, we'll never use more that 12!
      pga_perc = [18.000,10.900,6.900,4.900,4.100,3.625,3.375,3.125,2.925,2.725,2.525,2.325,2.125,1.925,1.825,1.725,1.625,1.525,1.425,1.325]

      percents = pga_perc[0..(places_paid -1)]
      sum = percents.sum
      @winners = Array.new(places_paid)
      percent_pot = percents.each_with_index do |v,i|
        percents[i] = v/sum 
      end
      # puts "PERC #{percents}  SUM #{percents.sum}"
      winners.each_with_index do |v,i|
        winners[i] = percents[i] * @pot
      end
      @winners = @winners.reverse
      # Things::Utilities.
      dollarize(@winners,@pot)

    end

  end
end
