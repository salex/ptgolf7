module Things
  class Deal1

    attr_accessor :winners, :payouts, :pot, :perc
    def initialize(numb_players,dues)
      @pot = numb_players * dues
      @winners = numb_players / 2
      @places = (1..@winners).to_a
      @perc = []
      @places.each{|v| @perc << v / @places.sum.to_f}
      @payouts = []
      @perc.each{|v| @payouts << round_to_quarters(v* @pot)}
      slush = ((@pot -payouts.sum)/0.25).to_i
      puts slush
      slush.times{|i|
        payouts[i] += 0.25
      }
      @winners = @payouts
    end

    def round_to_quarters(num)
      amt = ((num * 4).to_i / 0.25 / 4) * 0.25
    end

  end
end
