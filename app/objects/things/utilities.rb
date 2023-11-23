module Things
  module Utilities

    def hello
      return "Hello World"
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

