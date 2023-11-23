module Things
  class Utilities

    def self.hello
      return "Hello World"
    end

    def self.dollarize(winners,pot)
      # puts "start  #{winners} #{winners.sum}" 

      winners.each_with_index{|w,i| winners[i] = winners[i].round.to_f}
      if winners.sum != pot 
        diff = (winners.sum - pot).to_i
        # puts "diff #{diff}"
        if diff.negative?
          # pot short, add shortage to low players
          (diff*-1).times do |i|
            winners[i] += 1
          end
        else
          # pot over, subtract shortage to low players
          (diff).times do |i|
            winners[i] -= 1
          end
        end
      end
    end
  end
end

