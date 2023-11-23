



module Things
  class ScorePayPlaces
    # This computes a payout by place where each place get x% more than the previou place
    attr_accessor :rounds, :pay_places, :percents, :places_pot, :players,:place_winners, :payout
    def initialize(game,dues=nil)
      @rounds = game.scored_rounds
      get_percents(rounds)
      get_places_pot(rounds,dues)
      get_players(rounds)
      @payout = {}
      pot_idx = 0
      @place_winners.each_with_index do |w,i|
        size = w[1].size
        @payout[i] = {}
        @payout[i][:size] = size
        @payout[i][:players] = w[1].pluck(0)
        @payout[i][:pot] = @places_pot[pot_idx..(pot_idx + size - 1)].sum
        @payout[i][:each] = to_quarters(@payout[i][:pot] / size)
        pot_idx += @payout[i][:size]
      end
    end

    def get_percents(rounds)
      # percents is an array of distributions with
      # last percent 1.0 and each percent increased 
      # this array is then converted to percent in
      # get_places_pot
      # e.g @percents=[1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5]
      @pay_places = rounds.size / 2
      @percents = []
      0.upto(@pay_places - 1){|i| @percents[i] = 1.0}
      while @percents[1..-1].sum < @pay_places do 
        1.upto(@pay_places - 1){|i| @percents[i] +=  (i )/ 2.0}
      end
    end

    def get_places_pot(rounds,dues)
      # uses the percents distribution to convert to percents
      @places_pot = []
      perc_sum = @percents.sum
      pot = rounds.size * dues
      @percents.each do |pp|
        @places_pot << to_quarters( (pp * (100/perc_sum) / 100.0) * pot)
      end
      @places_pot = @places_pot.reverse
      # e.g @percents=[1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5]
      # is converted and reversed to
      # @places_pot=[19.5, 17.25, 15.25, 13.0, 10.75, 8.5, 6.5, 4.25]
    end

    def get_players(rounds)
      # get player index into rounds and points pulled as an array
      # that array is converted into a hash with the place being the key
      @players = []
      0.upto(rounds.size - 1){|i| @players << [i,rounds[i].total_net_pm]}
      @players = @players.sort_by{|i| i[1]}.reverse
      @place_winners = {}
      paid = 0
      @players.each do |p|
        if @place_winners[p[1]].present?
          paid += 1
          @place_winners[p[1]] << p
        else
          paid += 1
          break if paid > @pay_places
          @place_winners[p[1]] = [p] 
        end
      end

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
    def to_halfs(num,str=false)
      dollars = num.to_i
      cents = (num - dollars + 0.001).round(2) # can have float inaccracy
      quarters  = dollars + (cents * 2).floor * 0.5
      if str
        return format("%.2f", quarters)
      else
        return quarters
      end
    end

  end

end
