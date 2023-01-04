



module Things
  class PlacesPay
    # This computes a payout by place where each place get x% more that the previou pace
    # x - intially set to 40%, so if there are two place 
    #   last place gets 40%
    #   first place gets 60% 
    attr_accessor :pays, :percents, :perc, :winners_share
    def initialize(numb_players,dues=nil)
      @pays = numb_players / 2
      @perc = @pays >= 3 ? 1.4175 - (@pays * 0.0175) : 1.4 
      @percents = []
      0.upto(@pays - 1){|i| @percents << perc**i}
      @winners_share = []
      @percents.each do |pp|
        if dues.present?
          pot = numb_players * dues
          @winners_share << to_quarters( (pp * (100/@percents.sum) / 100.0) * pot)
        else
          @winners_share << pp * (100/@percents.sum)
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
  end

end
