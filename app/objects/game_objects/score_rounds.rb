# ScoreRounds only purpose is to take the form parameters and set
#   :front, :back, and :total attributes and save the round as a ScoredRount
# Scoring can be either a single team or all teams
# If any player is scored (round_change), Teams will be scored by callind the Scored{Method}
# The scored method will set all winners of the game and set status to Scored

class GameObjects::ScoreRounds
  attr_accessor :game, :rounds, :params

  def initialize(game, params)
    @game = game
    @rounds = game.rounds
    @params = params
    @method = game.method ||= Current.goup.pays
    score_rounds
  end

  def score_rounds
    rounds_changed = false
    params[:participant].each do |round_id, val|
      round = rounds.find_by(id: round_id)
      round.front = val['front']
      round.back = val['back']
      round.total = round.front + round.back
      round.type = 'ScoredRound'
      # only changed rounds saved. a recore teams may only change one player
      if round.changed?
        round.save
        round.player.recompute_quota(game.date)
        rounds_changed = true
      end
    end
    return unless rounds_changed
    # if a round has changed it may change quality
    # this will update team quality if needed and change status if needed
    # if the game is not scored, it will just get teams and rounds

    GameObjects::ScoreSides.new(game) if @method == 'sides'
    GameObjects::ScorePlaces.new(game)
  end
end
