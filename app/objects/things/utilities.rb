module Things
  module Utilities

    def hello
      return "Hello World"
    end

    def self.deal_10(places_paid,pot)
      payouts  = Array.new(places_paid,10)
      sum = payouts.sum
      rem = pot - sum 
      adders = (0..(places_paid-1)).to_a
      tms  = rem/places_paid -1
      puts "p #{pot} s #{sum} r #{rem} t #{tms} a #{adders.sum} ts #{rem/adders.sum}"
      (rem/adders.sum).times do 
        adders.each do |i|
          payouts[i] += adders[i] 
        end
      end
      # (pot - payouts.sum).times do |i|
      #   # puts "i #{i}"
      #   if i >=  places_paid
      #     i -= places_paid # set back to 0
      #     # puts "j #{i}"
      #   end
      #   payouts[i] += 1 
      # end
      payouts
    end


    def self.get_place_percents(places_paid,rate=nil)
      if rate.present?
        perc = [1.0,rate]
      else
        rate = 1.5 #  - (places_paid * 0.04)
        perc = [1.0,rate]
      end
      # puts "RATE #{rate}"
      (places_paid - 2).times do |i|
        last = perc[i+1]
        perc[i+2] = last*rate 
      end
      base_rate = 100/(perc.sum)
      places = [base_rate]
      1.upto(places_paid-1) do |i|
        places[i] = (places[i-1]* rate) 
      end
      places.each_with_index{|v,i| places[i] = (places[i]/100).round(4)}
    end

    def dollarize(winners,pot)
      # dollarize takes an array of floats (winners) and rounds each element
      #   to a whole number (up or down)
      winners.each_with_index{|w,i| winners[i] = winners[i].round.to_f}
      # the pot is a whole number that was equal to the sum of winners
      # now that elements are rounded, the pot may not equal the sum of winners
      if winners.sum != pot
        # get difference if not equal which may be negative or positive 
        diff = (winners.sum - pot).to_i
        # puts "DIFF #{diff}"
        if diff.negative?
          # sum of winners is short, add shortage to low winners
          (diff*-1).times do |i|
            winners[i] += 1
          end
        else
          # sum of winners is over, subtract shortage to high winners
          (diff).times do |i|
            winners[-i - 1] -= 1
          end
        end
        # the sum of the winners is now eqaul to the pot
      end
      # else fall through, rounding did not change the sum
    end
  end
end

