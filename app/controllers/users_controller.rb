class UsersController < ApplicationController
  before_action :require_current_group
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_manager, only: [:index,:show,:edit, :new, :create, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    if is_super?
      @users = User.all.includes(:group)
    else
      @users = Current.group.users
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = Current.group.users.build
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = Current.group.users.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def develop
  end 

  def signin
    #this is only used by signing in a developer (super)
    user = User.find_by_username(params[:email].downcase) || User.find_by_email(params[:email].downcase)
    if user && user.authenticate(params[:password]) && user.is_super?
      reset_session
      session[:user_id] = user.id
      session[:group_id] = params[:group][:id]
      current_user
      current_group
      session[:expires_at] = Time.now.midnight + 1.day
      redirect_to root_url, notice: "Logged in!"
    else
      redirect_to root_url, alert:  "Email or password is invalid"
    end
  end

  def logout
    group = current_group
    reset_session
    session[:group_id] = group.id
    cookies.delete("last_group_#{group.id}_user")
    redirect_to root_url, notice: "Logged out!"
  end

  def profile
    @user = current_user
  end

  def update_profile
    @user = User.find(params[:id])
    puts @user.inspect
    respond_to do |format|
      if @user.update(user_params)
        # password and confirmation can be blank if only updating username
        format.html { redirect_to root_path, notice: 'Profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'profile' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if is_super?
        @user = User.find(params[:id])
      else
        @user = Current.group.users.find_by(id:params[:id])
        if @user.blank?
          cant_do_that('Not Authorized - Player Unknown') unless is_coordinator?
        end
      end
    end

    def require_manager
      cant_do_that('Not Authorized') unless is_coordinator?
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:group_id, :player_id, :email, :username, {:role => []}, :password, :password_confirmation, :reset_token)
    end
end
