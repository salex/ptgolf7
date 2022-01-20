class GameObjects::ScheduledGame::FormTeams
  attr_accessor :option, :teams, :numb_players
  def initialize(numb_players,team_makeup,seed_method)
    # puts "p #{numb_players} m #{team_makeup} s #{seed_method}"
    @numb_players = numb_players
    @option = GameObjects::ScheduledGame::TeamOptions.new(numb_players).options[team_makeup]
    if @option.blank?
      @teams = nil 
      return(nil)
    end

    if team_makeup == "assigned"
      @teams = []
      1.upto(numb_players){|i| @teams << [i]}
      @teams = [@teams.flatten]
      return
    end

    if option['individual'].present?
      @teams = []
      1.upto(option['individual']){|i| teams << [i]}
    else
      @teams = send seed_method
    end
  end

  def abcd(random=false)
    # this just draws cards in seed order and created a deck
    # most forming method use this to create the deck, then modifiy it 
    abcd = []
    players = (1..numb_players).to_a
    # random make will shuffle players
    players.shuffle! if random
    numb_teams = option[:teams]
    numb_teams.times{abcd << players.shift(numb_teams)}
    # there will be orphans if mixed makeup and players will have elements left

    if players.size != 0
      numb_teams.times{abcd << players.shift(numb_teams)}
    end
    # there may be empty seeds, delete them
    abcd.delete([])
    abcd
  end

  def draw
    seed = abcd
    teams = []
    seed.each{|e| e.shuffle! }
    seed[0].size.times do |x|
      team = []
      seed.each{|i| team << i.shift}
      team.delete(nil)
      teams << team
    end
    teams.sort! { |x,y| x.count <=> y.count }
    teams
  end

  def seeded
    seed = abcd
    teams = []
    seed.each_with_index{|e,i| e.reverse! if i.odd?}
    seed[0].size.times do |x|
      team = []
      seed.each{|i| team << i.shift}
      team.delete(nil)
      teams << team
    end
    teams.sort! { |x,y| x.count <=> y.count }
    teams
  end


  def random
    seeded = abcd(true)
    teams = []
    seeded.each_with_index{|e,i| e.reverse! if i.odd?}
    seeded[0].size.times do |x|
      team = []
      seeded.each{|i| team << i.shift}
      team.delete(nil)
      teams << team
    end
    teams.sort! { |x,y| x.count <=> y.count }
    teams
  end

  def inline
    abcd = []
    @players = (1..numb_players).to_a
    if option['twosome']
      option['twosome'].times{abcd << shift2}
    end
    if option['threesome']
      option['threesome'].times{abcd << shift3}
    end

    if option['foursome']
      option['foursome'].times{abcd << shift4}
    end

    abcd.delete([])
    # puts "ABCD #{abcd.inspect}"

    abcd.sort! { |x,y| x.count <=> y.count }
    abcd
  end

  def shift2
    t = []
    t << @players.shift
    t << @players.pop
    t.flatten
  end

  def shift3
    t = []
    t << @players.shift
    t << @players.pop(2)
    # x = @players.size / 2
    # t << @players.delete_at(x)
    t.flatten
  end

  def shift4
    t = []
    t << @players.shift(2)
    t << @players.pop(2)
    t.flatten
  end

  def stacked
    abcd = []
    players = (1..numb_players).to_a.reverse
    if option['foursome']
      option['foursome'].times{abcd << [players.shift(2),players.pop(2)].flatten}
    end
    if option['threesome']
      option['threesome'].times{abcd << [players.shift(2),players.pop(1)].flatten}
    end
    if option['twosome']
      option['twosome'].times{abcd << [players.shift(1),players.pop(1)].flatten}
    end
    abcd.delete([])
    abcd.sort! { |x,y| x.count <=> y.count }
    abcd
  end

  def stacked_draw
    seed = abcd
    numb_teams = option[:teams]
    seed.each{|e| e.shuffle! }
    players = seed.flatten
    teams = []
    if option['foursome'] 
      option['foursome'].times{teams << [players.shift(2),players.pop(2)].flatten}
    end
    if option['threesome']
      option['threesome'].times{teams << [players.shift(2),players.pop(1)].flatten}
    end
    if option['twosome']
      option['twosome'].times{teams << [players.shift(1),players.pop(1)].flatten}
    end
    teams.delete([])
    teams.sort! { |x,y| x.count <=> y.count }
    teams
  end

  def abcd_battle
    abcd = []
    players = (1..numb_players).to_a.reverse
    if option['foursome'] 
      option['foursome'].times{abcd << players.shift(4)}
    end
    if option['threesome']
      option['threesome'].times{abcd << players.shift(3)}
    end
    if option['twosome']
      option['twosome'].times{abcd << players.shift(2)}
    end
    abcd.delete([])
    abcd.sort! { |x,y| x.count <=> y.count }
    abcd
  end

  def least_paired
    inline
  end

  def redistribution
    inline
  end

end
