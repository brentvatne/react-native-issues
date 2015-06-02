class PagesController < ApplicationController
  def index
    render json: Issue.open.all
  end
end
