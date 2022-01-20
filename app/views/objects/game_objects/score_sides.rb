class GameObjects::ScoreSides
  attr_accessor :scoring, :game, :rounds, :teams, :scored, :team_scores, :winners
  
  def initialize(game)
    @game = game
    @scoring = GameObjects::PlayersTeams.new(game)
    # get basic data form scoring
    @rounds = scoring.rounds
    @teams = scoring.teams
    @scored = scoring.scored

    @winners = {}.with_indifferent_access
    score_teams if scored
  end

  def best_front_players
    scoring.best_front_players
  end

  def best_back_players
    scoring.best_back_players
  end

  def best_total_players
    scoring.best_total_players
  end

  def is_winner?(team)
    team_scores[team].present? && !team_scores[team][:team_quality].zero?
  end

  def score_teams
    # extracts scoring elements team scored rounds
    @team_scores = {}
    teams.each do |team, mates|
      team_scores[team] = {}.with_indifferent_access
      team_scores[team][:quota] = mates.map(&:quota).sum
      team_scores[team][:side_quota] = team_scores[team][:quota] / 2.0
      team_scores[team][:front_net] =  mates.map(&:front_net).sum
      team_scores[team][:back_net] = mates.map(&:back_net).sum
      team_scores[team][:total_net] = mates.map(&:total_net).sum
      team_scores[team][:front_pm] = team_scores[team][:front_net] - team_scores[team][:side_quota]
      team_scores[team][:back_pm] =  team_scores[team][:back_net] - team_scores[team][:side_quota]
      team_scores[team][:total_pm] = team_scores[team][:total_net] - team_scores[team][:quota]
      team_scores[team][:mates] = mates.pluck(:id)
      team_scores[team][:team_quality] = 0.0
      team_scores[team][:mate_quality] = 0.0
    end
    team_back_winners
    team_front_winners
    team_total_winners

    rounds.each do |rnd|
      rnd.quality = team_scores[rnd.team][:mate_quality]
      rnd.save if rnd.total_changed? || rnd.quality_changed?
    end
    game.status = 'Scored' unless game.status == 'Scored'
    game.save if game.status_changed?
  end

  def team_front_winners
    best = team_scores.map { |_k, v| v[:front_pm] }.max
    who = []
    team_scores.each { |k, v| who << k if v[:front_pm] == best }
    winners[:front] = pay_side(who)
    winners[:front_size] = who.size
  end

  def team_back_winners
    best = team_scores.map { |_k, v| v[:back_pm] }.max
    who = []
    team_scores.each { |k, v| who << k if v[:back_pm] == best }
    winners[:back] = pay_side(who)
    winners[:back_size] = who.size
  end

  def team_total_winners
    best = team_scores.map { |_k, v| v[:total_pm] }.max
    who = []
    team_scores.each { |k, v| who << k if v[:total_pm] == best }
    winners[:total] = pay_side(who)
    winners[:total_size] = who.size
  end

  def pay_side(who)
    each_team = game.state[:side].to_f / who.size
    who.each do |t|
      ts = team_scores[t]
      ts[:team_quality] += each_team
      ts[:mate_quality] += (each_team / ts[:mates].size)
    end
    who
  end

end