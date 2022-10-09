class PlayersController < ApplicationController
  before_action :require_current_group
  before_action :set_player, only: [:show, :edit, :update, :destroy, :recompute_quota]
  before_action :require_manager, only: [:edit, :new, :create, :update, :destroy]


  # GET /players
  # GET /players.json
  def index
    group = Current.group
    if params[:table].blank?
      @expired,@active,@inactive = group.players_by_status
    else

      if params[:filter].present?
        @players = group.active_players.order(:name) if params[:filter] =='active'
        @players = group.inactive_players.order(:name) if params[:filter] =='inactive'
        @players = group.expired_players.order(:name) if params[:filter] =='expired'
      else
        @players = group.players.order(:name)
      end
      if @players.blank?
        redirect_to players_path, notice: "Players not found with status. #{params[:filter]}" 
      end

    end
  end

  # GET /players/1
  # GET /players/1.json
  def show
    @quota_summary =  PlayerObjects::Quota.get(@player)
    @pagy, @rounds = pagy(@player.scored_rounds.order(:date).reverse_order,items: 10)
  end

  # GET /players/new
  def new
    @player = Current.group.players.build(last_played:Date.today)

  end

  # GET /players/1/edit
  def edit
  end

  def recompute_quota
    @player.recompute_quota
    redirect_to @player, notice: 'Player quota recomputed.'
  end

  # POST /players
  # POST /players.json
  def create
    @player = Player.new(player_params)

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: 'Player was successfully created.' }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new, status: :unprocessable_entity}
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to players_url, notice: 'Player was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def player_search
    @search_results = Current.group.auto_search(params)
    puts "IN PLAYER SEARCH"
    if @search_results
      render template:'shared/pickr_search', layout:false
    end
  end

  def pairings_search
    @interactions = Player.pairing_search(params)
    render turbo_stream: turbo_stream.replace(
      'pairings',
      partial: 'pairings')

  end

  # def quota_correction
  #   if params[:perc].present?
  #     @perc = params[:perc].to_f.round(2)
  #   else
  #     @perc = 0.4
  #   end
  #   @players = QuotaCorrection.new(Current.group,'2020-05-31','2020-08-29',@perc).correction
  # end

  # def add_correction
  #   # if params[:perc].present?
  #   #   @perc = params[:perc].to_f.round(2)
  #   # else
  #   #   @perc = 0.4
  #   # end
  #   # @correction = QuotaCorrection.new(Current.group,'2020-05-31','2020-08-31',@perc)
  #   # @correction.add_correction_game
  #   redirect_to games_path, notice: 'A correction round cannot be added - window closed'
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = @current_group.players.find_by(id:params[:id])
      unless @player.present?
        redirect_to root_path, alert:'Group Player not found'
      end
    end

    def require_manager
      cant_do_that('Not Authorized') unless is_manager?
    end

    # Only allow a list of trusted parameters through.
    def player_params
      params.require(:player).permit(:group_id, :name, :first_name, :last_name, :nickname, :use_nickname, :tee, :quota, :rquota, :phone, :last_played, :is_frozen)
    end
end
