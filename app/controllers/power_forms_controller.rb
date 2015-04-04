class PowerFormsController < ApplicationController
  before_action :set_power_form, only: [:show, :edit, :update, :destroy]


  # GET /power_forms
  # GET /power_forms.json
  def index
    @power_forms = PowerForm.all
  end

  # GET /power_forms/1
  # GET /power_forms/1.json
  def show
    #run code here
    require 'csv'

    appliance = @power_form.appliance
    tstart = @power_form.tstart.strftime("%Y%m%d-%H%M")
    tend = @power_form.tend.strftime("%Y%m%d-%H%M")
    call = "/home/mike/anaconda/bin/python2.7 script.py "+appliance+" "+tstart+" "+tend

    system(call)

    #load parameters here
    disag = CSV.read('/home/mike/workspace/data/disag_output.csv')
    disag_hash = Hash[disag]
    @disag = disag_hash

    mains = CSV.read('/home/mike/workspace/data/mains_sum.csv')
    mains_hash = Hash[mains]
    @mains = mains_hash

    @chart_title = "Disaggregated "+@power_form.appliance.gsub("_"," ").capitalize+" Power"

    f1_scores = CSV.read('/home/mike/workspace/data/f1_results.csv')
    @f1_score = f1_scores

    en_per_meter = CSV.read('/home/mike/workspace/data/pred_results.csv')
    @en_per_meter = en_per_meter

    total_energy = 0

    t_en_file = File.open('/home/mike/workspace/data/total_energy.txt','r')
    t_en_file.each_line do |line|
      total_energy = line
    end
    t_en_file.close()

    @total_energy = total_energy

    total_time = 0

    t_time_file = File.open('/home/mike/workspace/data/total_time.txt','r')
    t_time_file.each_line do |line|
      total_time = line
    end
    t_time_file.close()

    @total_time = total_time

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
      params.require(:power_form).permit(:appliance, :tstart, :tend)
    end
end
