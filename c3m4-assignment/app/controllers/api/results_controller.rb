module Api
  class ResultsController < ApplicationController

    # GET /api/races/1/results
    # GET /api/races/1/results.json
    def index
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:race_id]}/results"
      else
        @race = Race.find(params[:race_id])
        @entrants = @race.entrants
        if stale?(last_modified: @race.entrants.max(:updated_at))
          fresh_when(last_modified: @race.entrants.max(:updated_at))
        end
      end
    end
  
    # GET /api/races/1/results/2
    # GET /api/races/1/results/2.json
    def show
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:race_id]}/results/#{params[:id]}"
      else
        @result = Race.find(params[:race_id]).entrants.where(:id=>params[:id]).first
        render :partial=>"result", :object=>@result
      end
    end
    
    # GET /api/races/1/results/new
    def new
    end
  
    # GET /api/races/1/results/2/edit
    def edit
    end
  
    # POST /api/races/1/results
    # POST /api/races/1/results.json
    def create
    end
  
    # PATCH/PUT /api/races/1/results/2
    # PATCH/PUT /api/races/1/results/2.json
    def update
      race = Race.find(params[:race_id])
      entrant = race.entrants.where(:id => params[:id]).first
      result = params[:result]
      if result
        if result[:swim]
          entrant.swim = entrant.race.race.swim
          entrant.swim_secs = result[:swim].to_f
        end
        if result[:t1]
          entrant.t1 = entrant.race.race.t1
          entrant.t1_secs = result[:t1].to_f
        end
        if result[:bike]
          entrant.bike = entrant.race.race.bike
          entrant.bike_secs = result[:bike].to_f
        end
        if result[:t2]
          entrant.t2 = entrant.race.race.t2
          entrant.t2_secs = result[:t2].to_f
        end
        if result[:run]
          entrant.run = entrant.race.race.run
          entrant.run_secs = result[:run].to_f
        end
        entrant.save
      end
      render plain: :nothing, status: :ok
    end
  
    # DELETE /api/races/1/results/2
    # DELETE /api/races/1/results/2.json
    def destroy
    end
  end
end