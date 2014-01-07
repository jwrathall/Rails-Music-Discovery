class IndexController < ApplicationController
  def new

  end
  def index

  end
  def search
     param = params['band']
     # fire up faraday
     # fix user input
     # figure out where api keys go
     # call api
     # 1. display json back
     # 2. figure out how to pump the json into angular
     render 'search_results'
  end
end
