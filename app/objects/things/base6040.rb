module Things
  class Base6040
    attr_accessor :winners,:pot, :percents
    include Things::Utilities

    def initialize(numb_players,dues,perc=nil)
      @pot = numb_players * dues.to_f 
      places_paid = numb_players / 2
      if perc.present?
        places_paid = (perc.to_f/100 * numb_players).to_i 
      else
        places_paid = numb_players / 2
      end
      @percents = Things::Utilities.get_place_percents(places_paid)
      sum = percents.sum
      @winners = Array.new(places_paid)
      percents.each_with_index do |v,i|
        percents[i] = v/sum 
      end
      winners.each_with_index do |v,i|
        winners[i] = percents[i] * @pot
      end
      @winners = @winners.reverse

      # Things::Utilities.
      dollarize(@winners,@pot)

    end
  end
end
