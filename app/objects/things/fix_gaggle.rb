module Things
  class FixGaggle

    def initialize
      # nilrnds = g.rounds.where(id: g.par3['player_good'].keys).where(par3:nil)
      group = Group.find(4)
      games = group.games.where('date >= ?',Date.today - 18.months).order(:date)
      games.each do |g|
        @scoring = GameObjects::ScorePlaces.new(g)
      end
    end

  end

end
