require 'net/http'
class WelcomeController < ApplicationController
	layout "application", :except => [:index]
  include RestGraph::RailsUtil
  before_filter :login_facebook, :only => [:login]
  before_filter :load_facebook, :except => [:login]
	def index
    if cookies[:KaSzakey] && cookies[:KaSzakey]!=""
        redirect_to '/main'
    else
        render :layout => false
    end	
		
	end

	def main 
    if cookies[:KaSzakey] && cookies[:KaSzakey]!=""
       rest_graph.access_token = cookies[:KaSzakey] 
       @access_token = rest_graph.access_token
    else 
      @access_token = rest_graph.access_token
      cookies[:KaSzakey] = { :value => rest_graph.access_token,:expires => 1.day.from_now}
    end  
      cookies[:KaSzakey] = { :value => rest_graph.access_token,:expires => 1.day.from_now}
	    if @access_token
	      @me = rest_graph.get('/me')
	    end
	end

  
  def login
    redirect_to '/main'
  end

  def logout
    reset_session
    cookies.delete(:KaSzakey)
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
