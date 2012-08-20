require 'net/http'
class WelcomeController < ApplicationController
	layout "application", :except => [:index]
  include RestGraph::RailsUtil
  #before_filter :login_facebook, :only => [:login]
  #before_filter :load_facebook, :except => [:login]
	def index
    	
		render :layout => false
	end

	def main
		#@access_token = rest_graph.access_token

	   # if @access_token
	    #  @me = rest_graph.get('/me')
	    #end
	end

  
  def login
    redirect_to '/'
  end

  def logout
    reset_session
    redirect_to '/'
  end
private
  def load_facebook
    rest_graph_setup(:write_session => true)
  end

  def login_facebook
    rest_graph_setup(:auto_authorize         => true,
                     :auto_authorize_scope   => 'publish_checkins',
                     :ensure_authorized      => true,
                     :write_session          => true)
  end
end
