class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy,:stats,:stats_refresh,:recompute_quotas,:trim_rounds]
  before_action :require_manager, only: [:edit, :new, :create, :update, :destroy,:recompute_quotas,:trim_rounds]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Current.club.groups
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Current.club.groups.build
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    # redirect_to plain_path(group_params)
    respond_to do |format|
      if @group.update_group(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def signin
    user = current_group.users.find_by(username:params[:email].downcase) || current_group.users.find_by(email:params[:email].downcase)
    remember_me = "remember_me_#{current_group.id}".to_sym
    if user && user.authenticate(params[:password])
      if params[remember_me].present?
        cookies[remember_me] = params[:email]
      else
        cookies.delete(remember_me)
      end
      reset_session
      session[:user_id] = user.id
      session[:group_id] = user.group_id
      session[:full_name] = user.name
      session[:expires_at] = Time.now.midnight + 1.day
      cookies["last_group_#{user.group_id}_user"] = {value: user.id, expires: Time.now.midnight + 1.day}
      redirect_to root_url, notice: "Logged in!"
    else
      # flash.now[:alert] = "Email or password is invalid"
      redirect_to login_url, alert:"Email or password is invalid"
    end
  end

  def logout
    group = current_group
    reset_session
    session[:group_id] = group.id
    cookies.delete("last_group_#{group.id}_user")
    redirect_to root_url, notice: "Logged out!"
  end

  def stats
    @groupStats = GroupStats.new
  end

  def stats_refresh
    @groupStats = GroupStats.new(params[:stats])
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('refresh', partial: 'groups/stats_refresh')}
      format.html { render :template => 'groups/stats'}
    end
  end

  def visit
    reset_session unless is_super?
    session[:group_id] = params[:id]
    redirect_to root_path
  end

  def leave
    reset_session unless is_super?
    redirect_to root_path
  end

  def fix_sidegames
    games = Current.group.games.where('date >= ?',Date.today - 100.days) 
    games.each{|g| GameObjects::Par3.new(g).pay_winners}
    games.each{|g| GameObjects::Skins.new(g).pay_winners}
    redirect_to root_path, notice:'Side Games fixed'
  end

  def print_quotas
    set_group
    @summary = @group.quota_summary
    render template:'groups/print_quotas', layout:'layouts/print'
  end

  def recompute_quotas
    @group.recompute_group_quotas
    redirect_to root_url, notice: "Group Quotas have be recomputed!"
  end

  def trim_rounds
    @group.trim_rounds
    redirect_to root_url, notice: "Group Events/Rounds over #{@group.trim_months} months old have be deleted and quotas recomputed"
  end

  def duplicate_other_player
    set_group
    oplayer = Player.find_by(id:params[:opid])
    if oplayer.present?
      nplayer = oplayer.dup
      nplayer.group_id = Current.group.id
      if nplayer.save
        redirect_to player_path(nplayer), notice: "Other player duplicated"
      else
        redirect_to root_path, notice: "Other player could not be saved! Contact developer"
      end
    else
      redirect_to root_path, alert:"Other Player not found. Could not duplicate"
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Current.group 
      if @group.blank?
        redirect_to root_path, alert:"Current Group not found"
      end
    end

    def require_manager
      cant_do_that('Not Authorized') unless is_manager?
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params.require(:group).permit(:club_id, :name, :tees,@group.default_options.keys)
       #  ["par_in", "par_out", "welcome", "alert",
       # "notice", "tee_time", "play_days", "dues", "skins_dues", "par3_dues", "other_dues", 
       # "truncate_quota", "pay", "limit_new_player", "limit_rounds", "limit_points",
       # "limit_new_tee",  "limit_new_tee_rounds","limit_new_tee_points",
       # "limit_frozen_player", "limit_frozen_points", "limit_inactive_player", "limit_inactive_days", 
       # "limit_inactive_rounds", "limit_inactive_points", "sanitize_first_round", "trim_months", 
       # "rounds_used", "use_hi_lo_rule", "default_stats_rounds"])
    end
end
