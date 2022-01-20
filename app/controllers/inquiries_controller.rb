class InquiriesController < ApplicationController
  before_action :set_inquiry, only: [:show, :edit, :update, :destroy]
  before_action :require_super, except: [:new,:create]


  # GET /inquiries
  # GET /inquiries.json
  def index
    @inquiries = Inquiry.all
  end

  # GET /inquiries/1
  # GET /inquiries/1.json
  def show
  end

  # GET /inquiries/new
  def new
    set_ptgolf
    @inquiry = @ptgolf.inquiries.new
  end

  # GET /inquiries/1/edit
  def edit
  end

  # POST /inquiries
  # POST /inquiries.json
  def create
    set_ptgolf
    @inquiry = @ptgolf.inquiries.new


    respond_to do |format|
      if @inquiry.update_inquiry(inquiry_params)
        format.html { redirect_to root_path, notice: 'Inquiry was successfully created.' }
        format.json { render :show, status: :created, location: @inquiry }
      else
        puts @inquiry.errors.inspect
        format.html { render :new }
        format.json { render json: @inquiry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inquiries/1
  # PATCH/PUT /inquiries/1.json
  def update
    respond_to do |format|
      if @inquiry.update_inquiry(inquiry_params)
        format.html { redirect_to inquiry_path(@inquiry.id), notice: 'Inquiry was successfully updated.' }
        format.json { render :show, status: :ok, location: @inquiry }
      else
        format.html { render :edit}
        format.json { render json: @inquiry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inquiries/1
  # DELETE /inquiries/1.json
  def destroy
    @inquiry.destroy
    respond_to do |format|
      format.html { redirect_to inquiries_url, notice: 'Inquiry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ptgolf
      @ptgolf = PointGolfer.find 1
    end

    def set_inquiry
      @inquiry = Inquiry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inquiry_params
      params.require(:inquiry).permit(:date,:inquiry => [:name,:email,:phone,:remarks,:real,:answer,:reply])
    end
end
