class RoundsController < ApplicationController
  before_action :require_current_group
  before_action :set_round, only: [:show, :edit, :update, :destroy]
  before_action :require_manager, only: [:edit, :new, :create, :update, :destroy]



  def show
  end

   # GET /root/1/edit
  def edit
  end

  def new
    nil
  end

  def create
    nil
  end

  # PATCH/PUT /root/1
  # PATCH/PUT /root/1.json
  def update
    group_player = @round.player
    respond_to do |format|
      if @round.update(round_params)
        group_player.recompute_quota
        format.html { redirect_to @round, notice: 'Round was successfully updated.' }
        format.json { render :show, status: :ok, location: @round }
      else
        format.html { render :edit, status: :unprocessable_entity}
        format.json { render json: @round.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /root/1
  # DELETE /root/1.json
  def destroy
    group_player = @round.player
    @round.destroy
    group_player.recompute_quota
    respond_to do |format|
      format.html { redirect_to group_player, status: :see_other, notice: 'Round was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_round
      @round = Round.find(params[:id])
    end

    def require_manager
      cant_do_that('Not Authorized') unless is_manager?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def round_params
      params.require(:round).permit(:date, :team, :quota,:tee,:front,:back,:total,:quality,:skins,:par3,:other)

    end
end
