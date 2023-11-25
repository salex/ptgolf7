class NoticesController < ApplicationController
  before_action :set_notice, only: [:show, :edit, :update, :destroy, :display]
  before_action :require_super


  # GET /inquiries
  # GET /inquiries.json

  def index
    @notices = Notice.all
  end

  # GET /inquiries/1
  # GET /inquiries/1.json
  def show
  end

  # GET /inquiries/new
  def new
    set_ptgolf
    @notice = @ptgolf.notices.new
  end

  # GET /inquiries/1/edit
  def edit
  end

  # POST /inquiries
  # POST /inquiries.json
  def create
    set_ptgolf
    @notice = @ptgolf.notices.new

    respond_to do |format|
      if @notice.update(notice_params)
        format.html { redirect_to root_path, notice: 'Notice was successfully created.' }
        format.json { render :show, status: :created, location: @notice }
      else
        format.html { render :new, status: :unprocessable_entity}
        format.json { render json: @notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inquiries/1
  # PATCH/PUT /inquiries/1.json
  def update
    respond_to do |format|
      if @notice.update(notice_params)
        format.html { redirect_to notice_path(@notice), notice: 'Notice was successfully updated.' }
        format.json { render :show, status: :ok, location: @notice }
      else
        format.html { render :edit, status: :unprocessable_entity}
        format.json { render json: @notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inquiries/1
  # DELETE /inquiries/1.json
  def destroy
    @notice.destroy
    respond_to do |format|
      format.html { redirect_to inquiries_url, notice: 'Notice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def display
    puts "Shoul dispay notice #{params[:id]}"
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ptgolf
      @ptgolf = PointGolfer.find 1
    end

    def set_notice
      @notice = Notice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notice_params
      params.require(:notice).permit(:date,:slim,:date_data,:status)
      # params.require(:inquiry).permit(:inquiry => [:name,:email,:phone,:remarks,:real,:answer])

    end
end
