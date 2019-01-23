module Api
  class RacersController < ApplicationController
  
    # GET /api/racers
    # GET /api/racers.json
    def index
      if !request.accept || request.accept == "*/*"
        render plain: "/api/racers"
      else
        #real implementation
      end
    end
  
    # GET /api/racers/1
    # GET /api/racers/1.json
    def show
      if !request.accept || request.accept == "*/*"
        render plain: "/api/racers/#{params[:id]}"
      else
        #real implementation
      end
    end
  
    # GET /api/racers/new
    def new
      @racer = Racer.new
    end
  
    # GET /api/racers/1/edit
    def edit
    end
  
    # POST /api/racers
    # POST /api/racers.json
    def create
    end
  
    # PATCH/PUT /api/racers/1
    # PATCH/PUT /api/racers/1.json
    def update
    end
  
    # DELETE /api/racers/1
    # DELETE /api/racers/1.json
    def destroy
    end
  end
end