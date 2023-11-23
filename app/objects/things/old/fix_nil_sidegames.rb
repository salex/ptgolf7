module Things
  class FixNilSidegames

    def initialize
      # nilrnds = g.rounds.where(id: g.par3['player_good'].keys).where(par3:nil)
      games = Game.where('date >= ?',Date.today - 18.months).order(:date)
      games.each do |g|
        fix_par3(g) if g.par3.present?
        fix_skins(g) if g.skins.present?
      end
    end

    def fix_par3(game)
      nilrnds = game.rounds.where(id: game.par3['player_good'].keys).where(par3:nil)
      puts "Fix par3 game #{game.id} nil rounds #{nilrnds.size}"
      nilrnds.update_all(par3:0.0) if nilrnds.size > 0
    end

    def fix_skins(game)
      nilrnds = game.rounds.where(id: game.skins['player_par'].keys).where(skins:nil)
      puts "Fix skins game #{game.id} nil rounds #{nilrnds.size}"
      nilrnds.update_all(skins:0.0) if nilrnds.size > 0
    end

  end

end
