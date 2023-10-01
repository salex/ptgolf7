module Things
  class DealPlaces
    attr_accessor :winners, :pot #, :perc_arr

    def initialize(numb_players,dues)
      @dues = dues.to_f
      @pot = numb_players * dues 
      @places_paid = numb_players / 2
      @winners = Array.new(@places_paid,@dues/2)
      deal
    end

    def round_to_quarters(num)
      amt = ((num * 4).to_i / 0.25 / 4) * 0.25
    end

    def deal

      while @winners.sum < @pot && ((@pot - @winners.sum) >= @dues) do 
        @winners.each_with_index do|v,i| 
          @winners[i] += 0.10 *(i+1)
        end
      end
      chg = (@pot -  @winners.sum) /  @winners.size
      @winners.each_with_index do|v,i| 
        @winners[i] += chg
        @winners[i] = round_to_quarters(@winners[i])
      end
      ink = (@pot -  @winners.sum)
      @winners[-1] += ink if ink.positive?
      # @winners.each_with_index{|e,i| @winners[i]=e.round.to_f}
      # diff = @pot - @winners.sum
      # # @winners << diff
      # @winners[-1] += diff if diff.positive?

      # @perc.each_with_index do |p,i|
      #   @winners[i] = round_to_quarters(@pot*(p/100.0))
      # end

    end

    def x
      arr = [1.0]
      1.upto(11) do |i|
        arr << arr[i-1] * 1.6 
      end
      puts arr
      arrs = [1.0]
      1.upto(11) do |i|
        arrs << arrs[i-1] + arr[i] 
      end
      puts arrs

    end
    # def perc
    #   0.upto(@places_paid - 1){|i| @perc_arr[i] = (i.to_f+1)}
    #   while (@perc_arr.sum < 100.0) do
    #     @perc_arr.each_with_index do |p,i|
    #       @perc_arr[i] += (i + 1)
    #     end
    #   end
    #   diff = (100.0 - @perc_arr.sum) / @perc_arr.size
    #   @perc_arr.each_with_index do |p,i|
    #     @perc_arr[i] += diff
    #   end
    # end
    
  end
end

