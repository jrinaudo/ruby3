module Api
  class EntriesController < ApplicationController

    # GET /api/racers/1/entries
    # GET /api/racers/1/entries.json
    def index
      if !request.accept || request.accept == "*/*"
        render plain: "/api/racers/#{params[:racer_id]}/entries"
      else
        #real implementation
      end
    end
  
    # GET /api/racers/1/entries/2
    # GET /api/racers/1/entries/2.json
    def show
      if !request.accept || request.accept == "*/*"
        render plain: "/api/racers/#{params[:racer_id]}/entries/#{params[:id]}"
      else
        #real implementation ...
      end
    end
    
    # GET /api/racers/entries/new
    def new
    end
  
    # GET /api/racers/entries/1/edit
    def edit
    end
  
    # POST /api/racers/entries
    # POST /api/racers/entries.json
    def create
    end
  
    # PATCH/PUT /api/racers/entries/1
    # PATCH/PUT /api/racers/entries/1.json
    def update
    end
  
    # DELETE /api/racers/entries/1
    # DELETE /api/racers/entries/1.json
    def destroy
    end
  end
end