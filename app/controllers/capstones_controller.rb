class CapstonesController < ApplicationController
  before_action :set_capstone, only: [:show, :edit, :update, :destroy]

  # GET /capstones
  # GET /capstones.json
  def index
    @capstones = Capstone.all
  end

  # GET /capstones/1
  # GET /capstones/1.json
  def show
  end

  # GET /capstones/new
  def new
    @capstone = Capstone.new
  end

  # GET /capstones/1/edit
  def edit
  end

  # POST /capstones
  # POST /capstones.json
  def create
    @capstone = Capstone.new(capstone_params)

    respond_to do |format|
      if @capstone.save
        format.html { redirect_to @capstone, notice: 'Capstone was successfully created.' }
        format.json { render action: 'show', status: :created, location: @capstone }
      else
        format.html { render action: 'new' }
        format.json { render json: @capstone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /capstones/1
  # PATCH/PUT /capstones/1.json
  def update
    respond_to do |format|
      if @capstone.update(capstone_params)
        format.html { redirect_to @capstone, notice: 'Capstone was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @capstone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /capstones/1
  # DELETE /capstones/1.json
  def destroy
    @capstone.destroy
    respond_to do |format|
      format.html { redirect_to capstones_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_capstone
      @capstone = Capstone.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def capstone_params
      params.require(:capstone).permit(:index, :number)
    end
end
