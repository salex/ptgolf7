module Things
  class FixGroupSettings

    def initialize
      # nilrnds = g.rounds.where(id: g.par3['player_good'].keys).where(par3:nil)
      json = Group.all.pluck(:id,:settings)
      # puts json.to_json
      File.write(Rails.root.join('app','objects','things','gsettings.json'),json.to_json)
    end

  end

end
