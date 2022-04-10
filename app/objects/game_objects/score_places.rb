class GameObjects::ScorePlaces
  attr_accessor :scoring, :game, :rounds, :teams, :scored, :team_scores, :winners, :percents
  
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
      team_scores[team][:total_net] =  mates.map(&:total_net).sum
      team_scores[team][:total_pm] = team_scores[team][:total_net] - team_scores[team][:quota]
      team_scores[team][:mates] = mates.pluck(:id)
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
    # team_scores[1][:total_pm] = 0   This was a test for last place tied
    placement = team_scores.map { |k, v| [v[:total_pm], k] }.sort # [pm_score,team]
    pays = placement.size / 2 # standard is to pay half of the teams - rounded
    placement_map = placement.map { |a| a[0] } # get the scores to find qualifiers in temp array
    qualifiers = placement_map[-pays..-1] # use map initially
    last_winner_score = qualifiers.first # lowest winning score
    last_winner_idx = placement_map.find_index(last_winner_score)
    qualifiers = placement[last_winner_idx..-1] # now get real qualifiers (score, team)
    @percents = set_place_percent(pays) # get the percentage for each place
    @winners = shuffle_places(qualifiers, percents)
  end

  def set_place_percent(pays)
    percents = Array.new(pays, 0.0)
    bump = pays > 6 ? 1.4 : 1.5 # set at least two tiers based on pays
    bump = pays > 11 ? 1.3 : bump
    last_guess = 0.25
    while percents.sum < 100.0
      percents[0] = last_guess
      1.upto(pays - 1) { |i| percents[i] = percents[i - 1] * bump }
      last_guess += 0.05
    end
    over = (percents.sum - 100) / pays # how much over 100 am I
    percents.each_index { |i| percents[i] -= over } # add the over to each percent
    percents.map { |i| (i / 100.0).round(4) } # convert to percentage
  end

  def shuffle_places(qualifiers, percents)
    # pop a qualifer and build an object
    # pop the next and if its a tie, add stuff to current place (team, percent) else set next place and pop percent
    pot = @game.state[:pot]
    scratch = {}.with_indifferent_access
    place = 1
    ateam = qualifiers.pop
    perc = percents.pop
    scratch[place] = {} # build scratch winners object starting with 1st place
    scratch[place][:pm] = ateam[0]
    scratch[place][:team] = [ateam[1]] # array because there may be ties
    scratch[place][:percent] = [perc]
    scratch[place][:quality] = 0.0
    scratch[place][:share] = 0.0
    while qualifiers.present? # would include a tie for last place team
      ateam = qualifiers.pop
      perc = percents.pop
      if ateam[0] == scratch[place][:pm]
        # puts " got a tie for place, add team and perc"
        scratch[place][:team] << ateam[1]
        scratch[place][:percent] << perc unless perc.nil?
      else
        # create the next place
        place += 1 # bump the place
        scratch[place] = {} # new object for the place
        scratch[place][:pm] = ateam[0]
        scratch[place][:team] = [ateam[1]]
        scratch[place][:percent] = [perc]
        scratch[place][:quality] = 0.0
        scratch[place][:share] = 0.0
      end
    end
    scratch.each do |_place, val|
      val[:quality] = (pot * val[:percent].sum).round(2) / val[:team].size
      val[:share] = (val[:quality] / val[:team].size).round(2)
      # loop thru place winners(ties) and set round quality
      val[:team].each do |t|
        mates_size = teams[t].size
        mate_quality = val[:share] / mates_size
        teams[t].each { |m| m.quality = mate_quality }
        team_scores[t][:team_quality] = val[:quality]
        team_scores[t][:mate_quality] = val[:share]
      end
    end
    scratch
    # goes into winners, should be all we need to pay winners
  end

end