module Things
  class MinPlace
    attr_accessor :winners, :pot, :perc
    # include Things::Utilities

    # pga current payouts
    # https://www.easyofficepools.com/pga-tour-payout-percentages-and-projected-earnings/
    def initialize(numb_players,dues,dist=nil,perc=nil)
      @pot = dues*numb_players
      idx = 0
      pga_perc.each_with_index do |i|
        cperc = i/100.0
        puts "PERC #{cperc} #{cperc*pot}"
        if pot * perc > 1.0
          # puts "#{i} #{pot*i/10.0}" 
          next
        else
          
          @perc = i
          break
        end
      end
      # puts "prtv #{pga_perc[idx]}"
    end

    def pga_perc
      pga_perc = [18.000,10.900,6.900,4.900,4.100,3.625,3.375,3.125,2.925,2.725,
        2.525,2.325,2.125,1.925,1.825,1.725,1.625,1.525,1.425,1.325,1.225,1.125,
        1.045,0.965,0.885,0.805,0.775,0.745,0.715,0.685,0.655]
    end
  end
end