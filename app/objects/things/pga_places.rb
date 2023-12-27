module Things
  class PgaPlaces
    attr_accessor :winners, :pot, :perc
    include PlacesHelper

    def initialize(numb_players,dues,dist=nil,perc=nil)
      dues = dues.to_f
      @pot = numb_players * dues 
   
      percents = pga_percents(numb_players,dist:dist,perc:perc)
      @winners = Array.new(percents.size)
      winners.each_with_index do |v,i|
        winners[i] = percents[i] * @pot
      end
      @winners = @winners.reverse
      dollarize(@winners,@pot)

    end

  end
end

