module Things
  class RatePlaces
    attr_accessor :winners, :purse, :places_paid

    def initialize(numb_players,dues)
      @dues = dues.to_f
      @purse = numb_players * @dues 
      @places_paid = numb_players / 2
      # @rate = Exonio.rate(9, 6,0, -108)
      if places_paid == 2
        @winners = [round_to_quarters(purse*0.4),round_to_quarters(purse*0.6)]
      else
        @rate = Exonio.rate(@places_paid, @dues,0, -@purse)
        @winners = [@dues]
        1.upto(@places_paid - 1) do |w|
          @winners[w] = round_to_quarters((1 + @rate ) * (winners[w-1]))
        end
      end
      # ink = (purse -  @winners.sum)
      # @winners[-1] += ink if ink.positive?
      Things::Utilities.dollarize(@winners,@purse)


      # @winners.each_with_index{|w,i| winners[i] = round_to_quarters(w)}


      # make_winners
      # @places_arr = (0..(@places_paid - 1)).to_a.reverse
      # @dues_return = (@purse / 2) / @places_arr.sum
      # @winners.each_with_index{|v,i| @winners[i] = round_to_quarters(@dues_return * @places_arr[i] + dues)}
    end

    # def make_winners
    #   @perc = [11.0, 7.8, 5.8, 4.8, 4.0, 3.6, 3.3, 3.1, 2.9, 2.7,
    #    2.5, 2.3, 2.1, 1.9, 1.7, 1.5, 1.4, 1.3, 1.2, 1.1]
    #   @winners = perc[0..(@places_paid -1)]
    #   diff = (100.0 -  @winners.sum) / @winners.size
    #   @winners.each_with_index{|w,i| @winners[i] += diff}
    # end

    def round_to_quarters(num)
      amt = ((num * 4).to_i / 0.25 / 4) * 0.25
    end

  end
end
