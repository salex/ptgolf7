class Games::ScoredController < GamesController
  before_action :set_game

  def show
    @game.method = Current.group.pays if @game.method.blank?
    valid = @game.rounds.length == @game.stats[:round][:players]
    case @game.method
    when 'sides'
      if valid
        @scoring = GameObjects::ScoreSides.new(@game)
        render template:'games/scored/show_sides'
      else
        render template:'games/invalid'
      end
    when 'places'
      if valid
        @scoring = GameObjects::ScorePlaces.new(@game)
        render template:'games/scored/show_places'
      else
        render template:'games/invalid'
      end
    end
  end

  def score_par3s
  end

  def score_skins
  end

  def rescore_teams
    render template:'games/pending/score_teams'
  end

  def update_skins
    pp = sidegame_params
    @game.pay_skins = pp
    redirect_to @game.namespace_url, notice: "Skins Side Games Updated"
  end

  def update_par3s
    pp = sidegame_params
    @game.pay_par3s = pp
    redirect_to @game.namespace_url, notice: "Par3 Side Games Updated"
  end

  private

  def set_game
    @game = Current.group.games.find_by(id:params[:id], status:'Scored')
    @game.set_state if @game.present?
    redirect_to( games_path, notice:"Scored game not found") if @game.blank?
  end

  def sidegame_params
    params.permit!.to_h
  end

end
