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
    if params[:event]
       @event =  params[:event]
    end
	end

  def getphoto
      @data = Array.new()
      
      @key = Account.where(:fb_id => params[:id]).first
      @pictures = @key.pictures
      @data << @pictures.count
      @pictures.each do |picture|
        @temp = Hash.new {}
        @temp[:image] =  picture.image.url(:thumb)
        @temp[:content] = picture.content
        @temp[:id] = picture.id
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
        @temp[:id] = picture.id
        @data << @temp
      end
      render json: @data
  end

  def postdata
    aFile = File.new('test.txt','w')
    @closed = Array.new()
    @all = Picture.all
    la = params[:latitude]
    lo = params[:longitude]
    @all.each do |target|
      tla = (target.latitude).to_f - la.to_f
      tlo = (target.longitude).to_f - lo.to_f
      if (tla*tla + tlo*tlo) < 1 
         @closed << target.id
      end
    end
    @picture=Picture.new(:image=>params[:image],:content=>params[:fbid],:latitude=>params[:latitude],:tag=>params[:tag],:longitude=>params[:longitude],:kind=>params[:kind])
    @picture.save
    @a = Account.where(:fb_id => params[:fbid]).first
    @kasza = Kasza.new(:account_id => @a.id,:picture_id => @picture.id)
    @kasza.save
    aFile.syswrite(@picture.id.to_s+"\n")
    for i in 0..@closed.count-1
    aFile.syswrite(@closed[i]+"\n")
    end
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

  def search
   @data = params[:id]
   render :layout => "searchpagelayout"
  end

  def searchshow
    @picture = Picture.find(params[:id])
    @tag = @picture
    @result = Picture.where(:tag=>@tag[:tag])
    @data = Array.new()
    @data << @result.count  
      

    @result.each do |picture|
        @temp = Hash.new {}
        @temp[:image] =  picture.image.url(:thumb)
        @temp[:content] = picture.content
        @temp[:id] = picture.id
        @data << @temp
    end
    render json:  @data
  end

  def photodetail
    @picture = Picture.find(params[:id])
  end

  def opencvfile
    aFile = File.new('test.txt','w')
    aFile.syswrite("yabi")
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

