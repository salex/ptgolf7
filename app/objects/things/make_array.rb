module Things
  class MakeArray
    attr_accessor :arr,:perc, :winners

    def initialize
      # @arr = [60.0,40.0] 
      # split_even    
    end

    def set_place_percents_new(pays,perc)
      percents = Array.new(pays, 1.0)
      while percents[1..-1].sum < pays do 
        1.upto(pays - 1){|i| percents[i] +=  (i )/ perc}
      end
      sum = percents.sum
      # np = []
      percents.each_with_index{|v,i| percents[i] = (v / sum).round(4)}
      @perc = percents

    end


    def make_arr(numb,dues)
      @dues = dues.to_f
      bumps = [1.6,1.58,1.56,1.54,1.52,1.5,1.48,1.46,1.44,1.42,1.40]
      guesses = [38.0,20.0,11.0,7.0,4.5,3.0,2.3,1.6,1.2,0.9,0.7]
      @purse = numb * dues 
      @places_paid = numb / 2
      bump = bumps[@places_paid-2]
      guess = guesses[@places_paid-2]
      @perc = Array.new(@places_paid - 1,guess)
      1.upto(@perc.size) do |i|
        @perc[i] = @perc[i-1] * bump
      end
      @winners = Array.new(@places_paid)
      diff = (100.0 - @perc.sum) / @places_paid
      puts "Diff #{diff} bump #{bump} guess #{guess} pp #{@places_paid - 2}"

      0.upto(@perc.size - 1){|i| @perc[i] += diff}

      0.upto(@perc.size - 1){|i| @winners[i] = (@perc[i] / 100.0) * @purse}
    end
      # @rate = Exonio.rate(9, 6,0, -108)

    def splite(arr)
      a4 = Array.new(3,0.0)
      a4[0] = arr[0]*0.4 
      a4[2] = arr[1]*0.6
      mid = 1.0 - a4.sum 
      a4[0] += mid*0.4*0.4*0.4
      a4[2] += mid*0.6*0.6*0.6
      a4[1] = 1.0 - (a4[0]+a4[2])
      

      @perc = a4

    end


    def split(a2,asum = nil)
      asum = asum.nil? ? 1.0 : asum
      a3 = Array.new(3,0.0)
      a3[0] = ((a2[0]*0.4)).round(3) 
      a3[1] = ((a3[0]*1.6)).round(3)
      a3[2] = ((a3[1]*1.6)).round(3)
      while(a3.sum < asum) do
        a3[0] = (a3[0] += 0.002).round(3)
        a3[1] = ((a3[0]*1.6)).round(3)
        a3[2] = ((a3[1]*1.6)).round(3)
      end
      a3[2] = asum - (a3[0] + a3[1])
      @perc = a3
    end

    def join(a3,asum = nil)
      asum = asum.nil? ? 1.0 : asum
      a2 = Array.new(2,0.0)
      a2[0] = a3[0] + (a3[1] * 0.4)
      a2[1] = a3[2] + (a3[1] * 0.6)
      puts a2.sum
      @perc = a2
    end






    def split_even(arr,asum = nil)
      @arr = arr
      asum = asum.nil? ? 100.0 : asum

      puts asum
      f60 = @arr[0] * 0.6
      f40 = @arr[0] * 0.4
      l60 = @arr[1] * 0.6
      l40 = @arr[1] * 0.4 
      mid_split = ((f40 + l60) / 2.0) * 0.6
      joined_arr = Array.new(3)
      joined_arr[0] = f60 + mid_split
      joined_arr[1] = l40 + mid_split
      joined_arr[2] = asum - (joined_arr[0] + joined_arr[1])
      @arr = joined_arr
    end

    def split_odd(arr,asum = nil)
      @arr = arr
      asum = asum.nil? ? 100.0 : asum
      asum = @arr.sum
      f60 = @arr[0] * 0.6
      f40 = @arr[0] * 0.4
      l60 = @arr[1] * 0.6
      l40 = @arr[1] * 0.4 
      mid_split = ((f40 + l60) / 2.0) * 0.6
      joined_arr = Array.new(4)
      joined_arr[0] = f60 + mid_split
      joined_arr[1] = l40 + mid_split
      left = 100.0 - joined_arr[0..1].sum
      puts "left #{left}"
      joined_arr[2] = left * 0.6
      joined_arr[3] = left - joined_arr[2]
      @arr = joined_arr

      puts joined_arr
    end

    def set_places_arr(places)
      bumps = [1.6,1.56,1.52,1.48,1.44,1.36,1.32,1.28,1.24,1.2,1.16,1.14]
      bmp = bumps[places]
      case places
      when 2
        @arr = [1.0,1.6]
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
        @perc << (@arr[i] + (@arr[i]/asum) * diff).round(4)
      end
    end

  end

end
# [18.0,10.8, 6.8, 4.8, 4, 3.6, 3.35, 3.1, 2.9, 2.7]
# [11.0, 8.8, 5.8, 4.8, 4.0, 3.6, 3.3, 3.1, 2.9, 2.7, 2.5, 2.3, 2.1, 1.9, 1.7, 1.5, 1.3, 1.3, 1.2]
