module Things
  class DealTokens
    attr_accessor :winners,:pot, :perc
    include Things::Utilities

    def initialize(numb_players,dues,dist=nil,perc=nil)
      @pot = numb_players * dues.to_f 
      # places_paid = numb_players / 2
      if perc.present?
        places_paid = (perc.to_f/100 * numb_players).to_i 
      else
        places_paid = numb_players / 2
      end

      if dist == 'high'
        min_payout = 0.5
      elsif dist == 'low'
        min_payout = 0.0
      elsif dist == 'top'
        min_payout = 0.0
      else
        dist = 'mid'
        min_payout = 1.0
      end
      pot_percents = self.deal_tokens(places_paid,min_payout,dist)
      @winners = Array.new(places_paid,min_payout)
      inc = pot - winners.sum 
      winners.each_with_index do |w,i|
        winners[i] += (pot_percents[i] * inc)
      end
      # Things::Utilities.
      dollarize(@winners,@pot)
    end

    def deal_tokens(places_paid,min_payout,dist)
      deal = (1..places_paid).to_a
      if dist == 'high'
        start = places_paid / 2 
        start.upto(places_paid - 1) do |i|
          deal[i] += 1
        end
      elsif dist == 'top'
        start = places_paid / 2 
        pos = (start..(places_paid - 1)).to_a
        pos.each_with_index do |e,i|
          deal[e] += i+1
        end
      end
      deal.each_with_index{|d,i| deal[i] += min_payout}
      sum  = deal.sum.to_f
      percents  = Array.new(places_paid)
      # convert tokens in each place to a percent
      0.upto(places_paid - 1) do |i|
       percents[i] =  deal[i] / sum
      end
      return percents
    end
  end
end

