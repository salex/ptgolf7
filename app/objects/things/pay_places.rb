module Things
  class PayPlaces
    attr_accessor :winners, :pot #, :perc

    def initialize(numb_players,dues)
      # @perc = [11.0, 8.8, 5.8, 4.8, 4.0, 3.6, 3.3, 3.1, 2.9, 2.7, 2.5, 2.3, 2.1, 1.9, 1.7, 1.5, 1.4, 1.3, 1.2]      
      dues = dues.to_f
      @pot = numb_players * dues 
      @places_paid = numb_players / 2
      @winners = Array.new(@places_paid,0.0)
      @places_arr = (0..(@places_paid - 1)).to_a
      @dues_return = (@pot / 2) / @places_arr.sum
      @winners.each_with_index{|v,i| @winners[i] = round_to_quarters(@dues_return * @places_arr[i] + dues)}
    end

    def round_to_quarters(num)
      amt = ((num * 4).to_i / 0.25 / 4) * 0.25
    end

  end
end
# [18.0,10.8, 6.8, 4.8, 4, 3.6, 3.35, 3.1, 2.9, 2.7]
# [11.0, 8.8, 5.8, 4.8, 4.0, 3.6, 3.3, 3.1, 2.9, 2.7, 2.5, 2.3, 2.1, 1.9, 1.7, 1.5, 1.4, 1.3, 1.2]