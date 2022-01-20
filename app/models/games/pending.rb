class Games::Pending < Game

  # attr_accessor :game_rounds, :teams, :stats
  attribute :game_rounds
  attribute :teams
  attribute :team_stats

  after_initialize :set_attributes


  def set_attributes
    self.set_state if self.state.blank?
    set_game_rounds
    set_teams
    set_team_stats
  end

  private
  
  def set_game_rounds
    self.game_rounds = current_players.each do |rnd|
      rnd.player_name = rnd.name
    end
  end

  def set_teams
    team_pointer = game_rounds.map(&:team)
    self.teams = {}
    team_pointer.each_with_index do |val,idx|
      if teams.has_key?(val)
        teams[val] << game_rounds[idx]
      else
        teams[val] = [game_rounds[idx]]
      end
    end
  end

  def set_team_stats
    # extracts scoring elements team scored rounds
    self.team_stats = {}
    teams.each do |team,mates|
      team_stats[team] = {}
      team_stats[team][:quota] = mates.map(&:quota).sum
      team_stats[team][:side_quota] = mates.map(&:side_quota).sum
    end

  end


end