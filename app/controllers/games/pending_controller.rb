class Games::PendingController < GamesController
  before_action :set_game, except: [:update_scores, :update_assigned_teams, :assign_teams,:score_teams]

  def show
    # @pending = Games::Pending.new(@game)
    @game = Games::Pending.find_by(id:params[:id])
  end

  def update
    # just adds player(s) to game
    respond_to do |format|
      if @game.update_participants(params)
        format.html { redirect_to @game.namespace_url, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { redirect_to root_path }
      end
    end
  end

  def add_players
    render template:'games/scheduled/show'
  end

  def score_card
    if @game.stats[:makeup] == "individuals" || @game.stats[:seed_method] == 'blind_draw'
      pdf =  Pdf::IndvScoreCard.new(@game)
    else
      pdf =  Pdf::ScoreCard.new(@game)
    end
    send_data pdf.render, filename: "score_card",
      type: "application/pdf",
      disposition: "inline"
  end
  
  def score_cardp
    pdf =  Pdf::ScoreCardp.new(@game)
    send_data pdf.render, filename: "score_card",
      type: "application/pdf",
      disposition: "inline"
  end

  def indv_score_card
    pdf =  Pdf::IndvScoreCard.new(@game)
    send_data pdf.render, filename: "score_card",
      type: "application/pdf",
      disposition: "inline"
  end



  def adjust_teams
    render template:'games/shared/assign_teams'
  end

  def assign_teams
    @game = Current.group.games.find(params[:id])
    render template:'games/shared/assign_teams'
  end


  def reform_teams
    @teams = GameObjects::ScheduledGame::TeamOptions.new(@game.state[:players])

    # @teams = Games::Teams::Form.new(@game.state[:players])
    render template: "games/scheduled/form_teams"
  end

  def swap_teams
  end

  def score_teams
    @game = Current.group.games.find_by(id:params[:id], status:['Pending','Scored'])
    @game.set_state if @game.present?

  end

  def update_assigned_teams
    @game = Current.group.games.find(params[:id])

    respond_to do |format|
      if @game.adjust_teams(params)
        # Games::Teams::Form.assign_teams(@game)
        format.html { redirect_to @game.namespace_url, notice: 'Game Teams successfully assigned.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { redirect_to root_path }
      end
    end
  end

  def update_scores
    @game = Current.group.games.find_by(id:params[:id], status:['Pending','Scored'])
    respond_to do |format|
      if GameObjects::ScoreRounds.new(@game,participant_params)
        flash.now[:notice] = 'Scoring Game Teams was successfull.'
        format.html { redirect_to @game.namespace_url, notice: 'Score Game Teams was successfull.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { redirect_to score_teams_path(@event), alert: "Score Events Teams was NOT successfull: #{@event.errors.messages}"}
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_game
    @game = Current.group.games.find_by(id:params[:id], status:'Pending')
    @game.set_state if @game.present?
    redirect_to( games_path, notice:"Pending game not found") if @game.blank?
  end

  def participant_params
    params.permit!.to_h
  end

end
