class GamesController < ApplicationController
  before_action :require_current_group
  before_action :set_game, only: [:show, :edit, :update, :destroy, :update]
  before_action :require_manager, except: [:index, :show]
  # GET /games
  # GET /games.json
  def index
    # @games = Current.group.games.order(:date).reverse_order
    @pagy, @games = pagy(Current.group.games.order(:date).reverse_order, items: 18)
  end

  # GET /games/1
  # GET /games/1.json
  def show
    if @game.status == "Scored"
      redirect_to games_scored_path(@game)
    end
  end

  # GET /games/new
  def new
    @game = Current.group.games.build(date:Date.today,method:Current.group.pay,status:'Scheduled')
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = Current.group.games.new(game_params)
    # ???? @game.update_players(params)
    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def new_today
    @game = Current.group.games.build(date:Date.today,method:Current.group.pay,status:'Scheduled')
    respond_to do |format|
      if @game.save
        format.html { redirect_to @game.namespace_url, notice: 'Game for today was successfully created' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    players = @game.players.pluck(:id)
    @game.destroy
    # if there were scored rounds, recompute quota
    gplayers = Player.find(players)
    gplayers.each do |p|
      p.recompute_quota
    end

    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    def require_current_group
      cant_do_that('Require Current Group') unless Current.group.present?
    end

    def require_manager
      cant_do_that('Not Authorized') unless is_manager?
    end

    # Only allow a list of trusted parameters through.
    def game_params
      params.require(:game).permit(:group_id, :date, :status, :method, :stats,:tees,:add_players,:deleted,skins:{},par3:{})
    end
end
