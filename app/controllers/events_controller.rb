class EventsController < ApplicationController

  # Find all the events for the Itinerary.js component in Trip.js given a trip id
  def events_by_trip
    @events_by_trip = Event.where("trip_id = #{params[:trip_id]}")
  end

  #Create new event from NewEvent.js component in Trip.js and send it back
  def create
    event = Event.new(event_params)
    event.save!
    render json: event
  end

  # Allows trip owner to delete events from Itinerary.js component in Trip.js
  def destroy
    event = Event.find(params[:id])
    event.destroy!
  end

  private

  def event_params
    params.require(:event).permit(:title, :location, :date, :description, :link, :trip_id)
  end

end
