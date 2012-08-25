class Picture < ActiveRecord::Base
  attr_accessible :content, :image, :kind, :latitude, :longitude, :tag
  has_many :kaszas
  has_many :accounts, :through => :kaszas
end
