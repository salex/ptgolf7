



module Things
  class PlacesPay
    # This computes a payout by place where each place get x% more than the previou place
    # x - intially set to 40%, so if there are two places: 
    #   last place gets 40%
    #   first place gets 60%  pro back mid front start
    attr_accessor :places, :percents, :winners
    def initialize(numb_players,dues=nil)
      @places = numb_players / 2
      @percents = Array.new(places,1.0)
      fudgeFactor = 0.035 * places

      1.upto(@places - 1){|i| @percents[i] =  @percents[i - 1] * (1.6 - fudgeFactor) }
      @winners = []
      @percents.each do |pp|
        if dues.present?
          pot = numb_players * dues
          @winners << to_quarters( (pp * (100/@percents.sum) / 100.0) * pot)
        else
          @winners << pp * (100/@percents.sum)
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

    def ptr_arr(size)
      arr = []
      1.upto(size){|i| arr << i}
      arr 
    end
    
    # def to_halfs(num,str=false)
    #   dollars = num.to_i
    #   cents = (num - dollars + 0.001).round(2) # can have float inaccracy
    #   quarters  = dollars + (cents * 2).floor * 0.5
    #   if str
    #     return format("%.2f", quarters)
    #   else
    #     return quarters
    #   end
    # end

  end

end
