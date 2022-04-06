module Things
  class RecoverPlayer

    def initialize
      player_json  = File.read(Rails.root.join('app','objects','things','player.json'))
      rounds_json  = File.read(Rails.root.join('app','objects','things','rounds.json'))
      @player = JSON.parse(player_json)
      @rounds = JSON.parse(rounds_json)
      recreate_player
      recreate_rounds
    end

    private

    def recreate_player
      Player.create!(@player)
    end

    def recreate_rounds
      @rounds.each do |r|
        r['type'] = "ScoredRound"
        Round.create!(r)
      end
    end

  end

end
