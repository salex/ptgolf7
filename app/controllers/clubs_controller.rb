class ClubsController < ApplicationController
  before_action :set_club, only: [:show, :edit, :update, :destroy]
  before_action :require_manager, only: [:edit, :new, :create, :update, :destroy]

  # GET /clubs
  # GET /clubs.json
  def index
    @clubs = Club.order(:name).all
  end

  def groups
    @clubs = Club.order(:name)  
  end
  
  def show
  end

  # GET /clubs/new
  def new
    @club = Club.new
  end

  # GET /clubs/1/edit
  def edit
  end

  # POST /clubs
  # POST /clubs.json
  def create
    @club = Club.new(club_params)

    respond_to do |format|
      if @club.save
        format.html { redirect_to @club, notice: 'Club was successfully created.' }
        format.json { render :show, status: :created, location: @club }
      else
        format.html { render :new, status: :unprocessable_entity}
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clubs/1
  # PATCH/PUT /clubs/1.json
  def update
    respond_to do |format|
      if @club.update(club_params)
        format.html { redirect_to @club, notice: 'Club was successfully updated.' }
        format.json { render :show, status: :ok, location: @club }
      else
        format.html { render :edit, status: :unprocessable_entity}
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clubs/1
  # DELETE /clubs/1.json
  def destroy
    @club.destroy
    respond_to do |format|
      format.html { redirect_to clubs_url, notice: 'Club was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def player_search
    @search_results = Current.group.club.auto_search(params)
    puts "IN PLAYER SEARCH"
    if @search_results
      render template:'shared/pickr_search', layout:false
    end
  end

  def player
    @player = Player.find(params[:pid])
    @quota_summary =  PlayerObjects::Quota.get(@player)

  end


  # def fix_settings
  #   if is_super?
  #     Fixes.new.fix_settings
  #     redirect_to root_path, notice: "Settings Fixed"
  #   else
  #     cant_do_that
  #   end
  # end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_club
      @club = Club.find(params[:id])
    end

    def require_manager
      cant_do_that('Not Authorized') unless is_manager?
    end


    # Only allow a list of trusted parameters through.
    def club_params
      params.require(:club).permit(:short_name, :name, :address, :city, :state, :zip, :phone, :par_in, :par_out, :tees)
    end
end
