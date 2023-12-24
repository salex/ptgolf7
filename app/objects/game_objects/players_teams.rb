class GameObjects::PlayersTeams
  attr_accessor :game, :rounds, :teams, :scored, :is_scored

  def initialize(game)
    @game = game
    game.set_state if game.state.blank?
    set_rounds
    set_teams
    @scored = @is_scored = rounds.size == rounds.map(&:type).count('ScoredRound')
  end

  # these methods should not be call unless scored
  def best_front_players
    best = rounds.map(&:front_pm).max
    who = []
    rounds.each_with_index { |rnd, idx| who << idx if rnd.front_pm == best }
    players = []
    who.each { |player| players << rounds[player].player_name }
    { score: best, players: players }
  end

  def best_back_players
    best = rounds.map(&:back_pm).max
    who = []
    rounds.each_with_index { |rnd, idx| who << idx if rnd.back_pm == best }
    players = []
    who.each { |player| players << rounds[player].player_name }
    { score: best, players: players }
  end

  def best_total_players
    best = rounds.map(&:total_pm).max
    who = []
    rounds.each_with_index { |rnd, idx| who << idx if rnd.total_pm == best }
    players = []
    who.each { |player| players << rounds[player].player_name }
    { score: best, players: players }
  end

  private

  attr_accessor :team_pointer

  def set_rounds
    @rounds = game.rounds.includes(:player).order(:team, 'players.rquota DESC')
    rounds.each do |rnd|
      rnd.player_name = rnd.name
      # only set net if round scored (e.g, it has a total)
      set_net(rnd) if rnd.total.present?
    end
    @team_pointer = rounds.map(&:team)
    # @team_numbers = team_pointer.uniq
  end

  def set_teams
    @teams = {}
    team_pointer.each_with_index do |val, idx|
      if teams.has_key?(val)
        teams[val] << rounds[idx]
      else
        teams[val] = [rounds[idx]]
      end
    end
  end

  def set_net(rnd)
    if rnd.limited.present?
      limit = rnd.limited.to_i
      rnd.front_net = get_limited_net(limit, rnd.front, rnd.side_quota)
      rnd.back_net = get_limited_net(limit, rnd.back, rnd.side_quota)
      rnd.total_net = get_limited_net(limit, rnd.total, rnd.quota)
    else
      rnd.front_net = rnd.front
      rnd.back_net = rnd.back
      rnd.total_net = rnd.total
    end
    rnd.quality = 0.0 # reset quality in case of a rescore
  end

  def get_limited_net(limit, points_pulled, quota)
    plus_minus = points_pulled - quota
    net = points_pulled
    if plus_minus.abs > limit
      net =  plus_minus.negative? ? (quota - limit) : (quota + limit)
    end
    net
  end

end
