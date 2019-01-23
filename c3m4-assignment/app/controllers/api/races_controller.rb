module Api
  class RacesController < ApplicationController

    # GET /api/races
    # GET /api/races.json
    def index
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races, offset=[#{params[:offset]}], limit=[#{params[:limit]}]"
      else
        #real implementation
      end
    end
  
    # GET /api/races/1
    # GET /api/races/1.json
    def show
    	if !request.accept || request.accept == "*/*"
    		render plain: "/api/races/#{params[:id]}"
    	elsif (request.accept.include? "application/xml") || (request.accept.include? "application/json") then
    		@race = Race.find(params[:id])
    		render action: :show, :status => :ok, :content_type => request.accept
    	end
    end
    
    # GET /api/races/new
    def new
      @race = Race.new
    end
  
    # GET /api/races/1/edit
    def edit
    end
  
    # POST /api/races
    # POST /api/races.json
    def create
      if !request.accept || request.accept == "*/*"
        render plain: "#{params[:race][:name]}", status: :ok
      else
        @race = Race.create(race_params)
        render plain: "#{params[:race][:name]}", status: :created
      end
    end
  
    # PATCH/PUT /api/races/1
    # PATCH/PUT /api/races/1.json
    def update
      Race.find(params[:id]).update(race_params)
      race = Race.find(params[:id])
      render json: race
    end
  
    # DELETE /api/races/1
    # DELETE /api/races/1.json
    def destroy
      Race.find(params[:id]).destroy
      render :nothing=>true, :status => :no_content
    end
    
    private
      def race_params
        params.require(:race).permit(:name, :date)
      end
  end
end