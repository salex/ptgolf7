module Things
  class EvenPlaces
    attr_accessor :winners, :pot, :perc , :arr
    include Things::Utilities


    def initialize(numb_players,dues)
      # @perc = [11.0, 8.8, 5.8, 4.8, 4.0, 3.6, 3.3, 3.1, 2.9, 2.7, 2.5, 2.3, 2.1, 1.9, 1.7, 1.5, 1.4, 1.3, 1.2]      
      @dues = dues.to_f
      @pot = numb_players * dues 
      @places_paid = numb_players / 2
      @winners = Array.new(@places_paid,1.0)
      set_places
      # puts "TEST #{@perc}"
      @perc.each_with_index do |p,i|
        # @winners[i] = round_to_quarters(@pot*(p/100.0))
        @winners[i] = @pot*(p/100.0)

      end
      # Things::Utilities.
      dollarize(@winners,@pot)

      # ink = (@pot -  @winners.sum)
      # @winners[-1] += ink if ink.positive?
    end

    def round_to_quarters(num)
      amt = ((num * 4).to_i / 0.25 / 4) * 0.25
    end

    def set_places
      # bumps = [1.6,1.8,1.45,1.325,1.2,1.175]
      # bumps = [1.6,1.56,1.52,1.48,1.44,1.36,1.32,1.28,1.24,1.2,1.16,1.14]
      bumps = [1.6,1.57,1.54,1.51,1.48,1.45,1.42,1.39,1.36,1.33,1.30,1.27]
      bmp = bumps[@places_paid - 1 ]
      case @places_paid
      when 2
        @arr = [1.0,1.5]
      when 3
        @arr = [1.0,bmp,bmp**2]
      when 4
        @arr = [1.0,bmp,bmp**2,bmp**3]
      when 5
        @arr = [1.0,bmp,bmp**2,bmp**3,bmp**4]
      when 6
        @arr = [1.0,bmp,bmp**2,bmp**3,bmp**4,bmp**5]
      when 7
        @arr = [1.0,bmp,bmp**2,bmp**3,bmp**4,bmp**5,bmp**6]
      when 8
        @arr = [1.0,bmp,bmp**2,bmp**3,bmp**4,bmp**5,bmp**6,bmp**7]
      when 9
        @arr = [1.0,bmp,bmp**2,bmp**3,bmp**4,bmp**5,bmp**6,bmp**7,bmp**8]
      when 10
        @arr = [1.0,bmp,bmp**2,bmp**3,bmp**4,bmp**5,bmp**6,bmp**7,bmp**8,bmp**9]
      when 11
        @arr = [1.0,bmp,bmp**2,bmp**3,bmp**4,bmp**5,bmp**6,bmp**7,bmp**8,bmp**9,bmp**10]
      when 12
        @arr = [1.0,bmp,bmp**2,bmp**3,bmp**4,bmp**5,bmp**6,bmp**7,bmp**8,bmp**9,bmp**10,bmp**11]
      end

      asum = @arr.sum
      diff = (100.0 - asum) 
      @perc = []
      @arr.each_with_index do |e,i|
        @perc << (@arr[i] + (@arr[i]/asum) * diff)
      end
    end

  end
end
# [18.0,10.8, 6.8, 4.8, 4, 3.6, 3.35, 3.1, 2.9, 2.7]
# [11.0, 8.8, 5.8, 4.8, 4.0, 3.6, 3.3, 3.1, 2.9, 2.7, 2.5, 2.3, 2.1, 1.9, 1.7, 1.5, 1.4, 1.3, 1.15]