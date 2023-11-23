module Things
  class DealPayPlaces

    attr_accessor :winners, :payouts, :pot, :cards, :slush
    def initialize(numb_players,dues)
      @pot = numb_players * dues
      @winners = numb_players / 2
      @payouts = Array.new(winners,dues/2) # everyone gets dues back
      @cards = pot - payouts.sum
      loop do
        #   puts "ds  #{payouts.sum} #{@cards} > #{winners} v #{@cards > winners}"
        1.upto(winners) do |w|
          deal_cards(w)
        end
        break if  @cards < (2..winners).sum
      end
      if cards > 0
        chg = ((cards*100)/(winners - 1)).to_i/25*0.25
        0.upto(payouts.size - 1) do |idx|
          payouts[idx] += chg
        end
        @slush = pot - payouts.sum
      end
    end

    def deal_cards(h)
      h.upto(winners) do |i|
        deal(i)
      end
    end

    def deal(place)
      from = place - 1 
      to = payouts.size - 1
      from.upto(to) do |idx|
        payouts[idx] += 0.25
        @cards -= 0.25
      end
    end

  end
end
