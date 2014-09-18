class DtcsController < ApplicationController
  before_action :set_dtc, only: [:show, :edit, :update, :destroy]

  # GET /dtcs
  # GET /dtcs.json
  def index
    @dtcs = Dtc.all
  end

  # GET /dtcs/1
  # GET /dtcs/1.json
  def show
  end

  # GET /dtcs/new
  def new
    @dtc = Dtc.new
  end

  # GET /dtcs/1/edit
  def edit
  end

  # POST /dtcs
  # POST /dtcs.json
  def create
    @dtc = Dtc.new(dtc_params)

    respond_to do |format|
      if @dtc.save
        format.html { redirect_to @dtc, notice: 'Dtc was successfully created.' }
        format.json { render action: 'show', status: :created, location: @dtc }
      else
        format.html { render action: 'new' }
        format.json { render json: @dtc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dtcs/1
  # PATCH/PUT /dtcs/1.json
  def update
    respond_to do |format|
      if @dtc.update(dtc_params)
        format.html { redirect_to @dtc, notice: 'Dtc was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @dtc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dtcs/1
  # DELETE /dtcs/1.json
  def destroy
    @dtc.destroy
    respond_to do |format|
      format.html { redirect_to dtcs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dtc
      @dtc = Dtc.find(params[:id])
      @fitments = Fitment.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dtc_params
      params.require(:dtc).permit(:code, :description, :meaning, :system, :source, :fitment_ids => [])
    end
end
