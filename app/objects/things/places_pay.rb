module Things
  class PlacesPay
    attr_accessor :perc_array, :last_pays, :pay, :pay_array
    def initialize(numb_players)
      @pay = numb_players / 2 

      @perc_array = [1.0]
      if @pay > 1
        # the below modifies the 40/60 payout by decreasing the ratio
        # slightly based on number of pays
        perc = 1 + (1.6 / @pay) 
        1.upto(@pay - 1){|i| @perc_array << perc**i}
      end
      @last_pays = 100 / @perc_array.sum
      @pay_array = []
      pot = numb_players * 8
      @perc_array.each do |x|
        @pay_array << to_quarters((@last_pays * x) / 100 * pot)

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
