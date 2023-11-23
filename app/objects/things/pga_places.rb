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
        places_paid = (perc.to_f/100 * numb_players).round 
      else
        places_paid = numb_players / 2
      end
      # perc = [11.0, 7.8, 5.8, 4.8, 4.0, 3.6, 3.3, 3.1, 2.9, 2.7,
      #  2.5, 2.3, 2.1, 1.9, 1.7, 1.5, 1.4, 1.3, 1.2, 1.1]
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

          # make_winners
          # @places_arr = (0..(@places_paid - 1)).to_a.reverse
          # @dues_return = (@pot / 2) / @places_arr.sum
          # @winners.each_with_index{|v,i| @winners[i] = (@dues_return * @places_arr[i] + dues)}
          # puts "Winners #{@winners}"
          # # Things::Utilities.dollarize(@winners,@pot)

    end

    # def make_winners
    #   @perc = [11.0, 7.8, 5.8, 4.8, 4.0, 3.6, 3.3, 3.1, 2.9, 2.7,
    #    2.5, 2.3, 2.1, 1.9, 1.7, 1.5, 1.4, 1.3, 1.2, 1.1]
    #   @winners = perc[0..(@places_paid -1)]
    #   diff = (100.0 -  @winners.sum) / @winners.size
    #   @winners.each_with_index{|w,i| @winners[i] += diff}
    # end

    # def round_to_quarters(num)
    #   amt = ((num * 4).to_i / 0.25 / 4) * 0.25
    # end

  end
end
