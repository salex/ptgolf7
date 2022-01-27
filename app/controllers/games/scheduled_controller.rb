class Games::ScheduledController < GamesController
  before_action :set_game, except: [:update_teams,:update_assigned_teams]
  before_action :require_manager


  def show
  end

  def update
    # just adds player(s) to game
    respond_to do |format|
      if @game.update_participants(params)
        format.html { redirect_to games_scheduled_path(@game), notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
        # format.turbo_stream { render turbo_stream: turbo_stream.replace('schedulers', partial: 'games/scheduled/scheduler') }

      else
        format.html { redirect_to root_path }
      end
    end
  end

  def form_teams
    # gets the form teams form
    @teams = GameObjects::ScheduledGame::TeamOptions.new(@game.state[:players])
  end

  def update_teams
    # responds to update teams form
    @game  = Games::Scheduled.find_by(id:params[:id])
    ok = @game.form_teams(params[:team_makeup], params[:seed_method])
    if ok 
      redirect_to @game.namespace_url, notice:'Teams have been formed'
    else
      redirect_to games_path, alert:'something screwed up, teams not formed'
    end
  end

  def assign_teams
    render template:'games/shared/assign_teams'
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Current.group.games.find_by(id:params[:id], status:'Scheduled')
      @game.set_state if @game.present?
      redirect_to( games_path, notice:"Scheduled game not found") if @game.blank?
    end

end
