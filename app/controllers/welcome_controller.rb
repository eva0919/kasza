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
      redirect_to '/'
    end  
      cookies[:KaSzakey] = { :value => rest_graph.access_token,:expires => 1.month.from_now}
	    if @access_token
	      @me = rest_graph.get('/me')
	    end
	end

  def getphoto
      @data = Array.new()
      
      @key = Account.where(:fb_id => params[:id]).first
      @pictures = @key.pictures

      @pictures.each do |picture|
        @temp = Hash.new {}
        @temp[:image] =  picture.image.url(:thumb)
        @temp[:content] = picture.content
        @data << @temp
      end
      render json: @data
  end

  def getphoto_phone
      @data = Array.new()
      
      @key = Account.where(:fb_id => params[:id]).first
      @pictures = @key.pictures

      @pictures.each do |picture|
        @temp = Hash.new {}
        @temp[:image] =  picture.image.url(:thumb)
        @temp[:content] = picture.content
        @data << @temp
      end
      render json: @data
  end




  
  def login
    @me = rest_graph.get('/me')
    if Account.where(:fb_id => @me['id']).count > 0
    else
    @account = Account.new(:fb_id => @me['id'])
    @account.save
    end
    cookies[:KaSzakey] = { :value => rest_graph.access_token,:expires => 1.month.from_now}
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

