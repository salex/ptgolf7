module Things
  class TestParams
    attr_accessor :one, :two

    # pga current payouts
    # https://www.easyofficepools.com/pga-tour-payout-percentages-and-projected-earnings/
    def initialize(one,two,three:nil,four:nil)
      puts "one #{one} two #{two} three #{three} four #{four}"
    end
  end
end
