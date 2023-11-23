module Things
  class VarPlaces
    attr_accessor :winners, :purse, :perc

    def initialize(numb_players,dues)
      dues = dues.to_f
      @purse = numb_players * dues 
      places_paid = numb_players / 2
      perc = [11.0, 7.8, 5.8, 4.8, 4.0, 3.6, 3.3, 3.1, 2.9, 2.7,
       2.5, 2.3, 2.1, 1.9, 1.7, 1.5, 1.4, 1.3, 1.2, 1.1]
      percents = perc[0..(places_paid -1)]
      sum = percents.sum
      @winners = Array.new(places_paid)
      percent_pot = percents.each_with_index do |v,i|
        percents[i] = v/sum 
      end
      # puts "PERC #{percents}  SUM #{percents.sum}"
      winners.each_with_index do |v,i|
        winners[i] = percents[i] * @purse
      end
      @winners = @winners.reverse
      Things::Utilities.dollarize(@winners,@purse)


          # make_winners
          # @places_arr = (0..(@places_paid - 1)).to_a.reverse
          # @dues_return = (@purse / 2) / @places_arr.sum
          # @winners.each_with_index{|v,i| @winners[i] = (@dues_return * @places_arr[i] + dues)}
          # puts "Winners #{@winners}"
          # # Things::Utilities.dollarize(@winners,@purse)

    end

    def make_winners
      @perc = [11.0, 7.8, 5.8, 4.8, 4.0, 3.6, 3.3, 3.1, 2.9, 2.7,
       2.5, 2.3, 2.1, 1.9, 1.7, 1.5, 1.4, 1.3, 1.2, 1.1]
      @winners = perc[0..(@places_paid -1)]
      diff = (100.0 -  @winners.sum) / @winners.size
      @winners.each_with_index{|w,i| @winners[i] += diff}
    end

    # def round_to_quarters(num)
    #   amt = ((num * 4).to_i / 0.25 / 4) * 0.25
    # end

  end
end
