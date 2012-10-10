require 'net/http'
class PicturesController < ApplicationController
  include RestGraph::RailsUtil
  before_filter :login_facebook, :only => [:login]
  before_filter :load_facebook, :except => [:login]
  # GET /pictures
  # GET /pictures.json
  def index
    @pictures = Picture.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pictures }
    end
  end

  # GET /pictures/1
  # GET /pictures/1.json
  def show
    @picture = Picture.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @picture }
    end
  end

  # GET /pictures/new
  # GET /pictures/new.json
  def new
    @picture = Picture.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @picture }
    end
  end

  # GET /pictures/1/edit
  def edit
    @picture = Picture.find(params[:id])
  end


  # POST /pictures
  # POST /pictures.json
  def create
    @picture = Picture.new(params[:picture])
    @picture.save
    rest_graph.access_token = cookies[:KaSzakey]
    @me = rest_graph.get('me')
    @a = Account.where(:fb_id => @me['id']).first
    @kasza = Kasza.new(:account_id => @a.id,:picture_id => @picture.id)
    @kasza.save
    # 算經緯度   如果算出來的差值小於10 就將他的id存下來 用陣列存取 陣列第一個數字是 要被比對的照片的id
    @closed = Array.new()
    @all = Picture.all
    la = @picture.latitude
    lo = @picture.longitude
    #@closed << params[:fbid]
    @all.each do |target|
      tla = (target.latitude).to_f - la.to_f
      tlo = (target.longitude).to_f - lo.to_f
      if ( (tla*tla + tlo*tlo) < 1 ) && (target.id != @picture.id)
         @closed << target.id.to_s
      end
    end
    #將經緯度差距的圖片用txt文字檔存起來，在目錄picstory之下 （並不是在picstory/app之下）
    aFile = File.new('test.txt','w')
    aFile.syswrite(@picture.id.to_s+"\n")
    aFile.syswrite(@closed)
    respond_to do |format|
      if @picture.save
        format.html { redirect_to '/main', notice: 'upload' }
        format.json { render json: @picture, status: :created, location: @picture }
      else
        format.html { render action: "new" }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pictures/1
  # PUT /pictures/1.json
  def update
    @picture = Picture.find(params[:id])

    respond_to do |format|
      if @picture.update_attributes(params[:picture])
        format.html { redirect_to '/main', notice: 'upload' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.json
  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy

    respond_to do |format|
      format.html { redirect_to pictures_url }
      format.json { head :no_content }
    end
  end

  # get /pictures/search/1
  # 尋找id=1 相同tag的照片
  def search
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
      render json: @data
  end

  #pictures/matchtag
  def matchtag
  end



################################################

    def login
    @me = rest_graph.get('/me')
    if Account.where(:fb_id => @me['id'])
    else
    @account = Account.new(:fb_id => @me['id'])
    @account.save
    end
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
