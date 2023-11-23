module Things
  class DealPlaces
    attr_accessor :winners,:pot #, :perc_arr

    def initialize(numb_players,dues)
      @pot = numb_players * dues.to_f 
      places_paid = numb_players / 2
      min_payout = 0
        #hard coded to at least 1 card/token for each place
        # this evens out distribution
      pot_percents = self.deal_cards(places_paid,min_payout)
      @winners = Array.new(places_paid,min_payout)
      inc = pot - winners.sum 
      winners.each_with_index do |w,i|
        winners[i] += (pot_percents[i] * inc)
      end
      # puts "start  #{winners} #{winners.sum}" 
      Things::Utilities.dollarize(@winners,@pot)
      # puts "end  #{winners} #{winners.sum}" 

    end

    def deal_cards(places_paid,min_payout)
      deal = (1..places_paid).to_a
      deal.each_with_index{|d,i| deal[i] += min_payout}
      sum  = deal.sum.to_f
      percents  = Array.new(places_paid)
      # convert cards in each place to a percent
      0.upto(places_paid - 1) do |i|
        percents[i] =  deal[i] / sum
      end
      return percents
    end
   end
end

