class PagesController < ApplicationController
	include PagesHelper

  def index
  end

  def about
  end

	def m6slots
		@picked_slots = match6slots
	end

	def pballslots
		@picked_slots = fetch_powerball_data
	end
end
