class PowerFormsController < ApplicationController
  before_action :set_power_form, only: [:show, :edit, :update, :destroy]

  #rails generate scaffold PowerForm appliance:string starttime:datetime endtime:datetime
  #http://localhost:3000/power_forms/new
  # GET /power_forms
  # GET /power_forms.json
  def index
    @power_forms = PowerForm.all
  end

  # GET /power_forms/1
  # GET /power_forms/1.json
  def show
  end

  # GET /power_forms/new
  def new
    @power_form = PowerForm.new
  end

  # GET /power_forms/1/edit
  def edit
  end

  # POST /power_forms
  # POST /power_forms.json
  def create
    @power_form = PowerForm.new(power_form_params)

    respond_to do |format|
      if @power_form.save
        format.html { redirect_to @power_form, notice: 'Power form was successfully created.' }
        format.json { render :show, status: :created, location: @power_form }
      else
        format.html { render :new }
        format.json { render json: @power_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /power_forms/1
  # PATCH/PUT /power_forms/1.json
  def update
    respond_to do |format|
      if @power_form.update(power_form_params)
        format.html { redirect_to @power_form, notice: 'Power form was successfully updated.' }
        format.json { render :show, status: :ok, location: @power_form }
      else
        format.html { render :edit }
        format.json { render json: @power_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /power_forms/1
  # DELETE /power_forms/1.json
  def destroy
    @power_form.destroy
    respond_to do |format|
      format.html { redirect_to power_forms_url, notice: 'Power form was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_power_form
      @power_form = PowerForm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def power_form_params
      params.require(:power_form).permit(:appliance, :starttime, :endtime)
    end
end