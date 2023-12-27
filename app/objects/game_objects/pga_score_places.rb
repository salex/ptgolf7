class GameObjects::PgaScorePlaces
  include PlacesHelper
  
  attr_accessor :scoring, :game, :rounds, :teams, :team_scores, :winners, :percents, :payouts
  
  def initialize(game)
    @game = game
    # there a 4 level of spread 0=high 1=mid 2=low 4=even
    group = game.group
    dist = group.score_place_dist ||= 'mid'
    perc = group.score_place_perc ||= 50

    @scoring = GameObjects::PlayersTeams.new(game)
    # get basic data form scoring
    @rounds = scoring.rounds
    @teams = scoring.teams
    # set other class variables
    @pot = game.state[:pot]
    @has_idividual_teams = @rounds.size == @teams.size
    @percents = pga_percents(teams.size,dist:dist,perc:perc)
    @winners = {}.with_indifferent_access
    score_teams if scoring.is_scored
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

  def place_winners
    place_winners = {}
    place = 0
    winners.each do |pm,tms|
      pays = format("%.2f", payouts[place][:dollars])
      str = " Team #{tms}  &#177; #{pm} Won: $#{pays}"
      place_winners[place] = str
      place+=1
    end
    place_winners
  end

  def is_winner?(team)
    team_scores[team].present? && !team_scores[team][:team_quality].zero?
  end

  def score_teams
    # extracts scoring elements team scored rounds
    @team_scores = {}
    teams.each do |team, mates|
      # THIS IS WHERE TEAM SCORES ARE SET WITH TOTAL-NET MAP
      team_scores[team] = {}.with_indifferent_access
      team_scores[team][:quota] = mates.map(&:quota).sum
      team_scores[team][:side_quota] = team_scores[team][:quota] / 2.0
      team_scores[team][:total_net] =  mates.map(&:total_net).sum
      team_scores[team][:total_pm] = team_scores[team][:total_net] - team_scores[team][:quota]
      team_scores[team][:mates] = mates.pluck(:player_name)
      team_scores[team][:team_quality] = 0.0
      team_scores[team][:mate_quality] = 0.0
    end
    team_total_winners
    rounds.each do |rnd|
      rnd.quality = team_scores[rnd.team][:mate_quality]
      rnd.save if rnd.total_changed? || rnd.quality_changed?
    end
    game.status = 'Scored' unless game.status == 'Scored'
    game.save if game.status_changed?
  end

  def team_total_winners
    # sort the team scores
    placement = team_scores.map { |k, v| [v[:total_pm], k] }.sort.reverse 
    # SET QUALIFIERS
    last_winner_score = placement[percents.size - 1][0] 
    qualifiers = []
    #  set qualifiers to all teams greater or equal to the last_winner_score
    placement.each do |e|
      if e[0] >= last_winner_score
        qualifiers << e 
      end
    end
    # SET WINNERS
    @winners = {}
    # create winners hash with a key = qualifiers plus-minus points pulled
    # and value all rounds that had the pm (ties)
    0.upto(qualifiers.length - 1) do |idx|
      pts = qualifiers[idx][0]
      if winners.has_key?(pts)
        # if key found, add player/round index
        winners[pts] << qualifiers[idx][1]
      else
        # else create a new key
        winners[pts] = [qualifiers[idx][1]]
      end
    end
    #SET PAYOUTS
    # create an array of hashes that adds winner attributes
    @payouts = []
    place = 0 # first place
    winners.each do |k,v|
      nxt = v.size + place # set next place
      pp = percents[place..(nxt -1)]
      pp_sum = pp.sum
      ea = pp_sum / v.size
      won = {place: place, players:v,percents:pp_sum,share:ea,dollars:pp_sum*@pot,dollars_share:ea*@pot}
      payouts << won
      place = nxt 
    end
    #dolarize
    dollars = payouts.map{|i| i[:dollars]}
    dollarize(dollars,@pot)
    dollars.each_with_index do |v,i|
      payouts[i][:dollars] = v
      payouts[i][:dollars_share] = v
    end
    set_places
  end

  def set_places
    payouts.each do |place|
      ties = place[:players].size
      place[:players].each do |mate|
        team = teams[mate][0].team
        ts = team_scores[team]
        ts[:team_quality] = place[:dollars]/ties
        if @has_idividual_teams
          ts[:mate_quality] = ts[:team_quality]
        else
          ts[:mate_quality] = round_to_quarters(ts[:team_quality]/ts[:mates].size)
        end
      end
    end
  end

  def round_to_quarters(num)
    amt = ((num * 4).to_i / 0.25 / 4) * 0.25
  end

end