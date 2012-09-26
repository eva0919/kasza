class Picture < ActiveRecord::Base
  attr_accessible :content, :image, :kind, :latitude, :longitude, :tag
  has_attached_file :image, :path => ":rails_root/app/assets/images/KaSza/:id.jpg", :url => "/assets/KaSza/:id.jpg", :default_url => "/assets/KaSza/:id.jpg"
  has_many :kaszas
  has_many :accounts, :through => :kaszas
end
