class ApplicationController < ActionController::Base
  def create
    session[:cumulative_score] = 0
  end
end
