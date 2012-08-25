class Account < ActiveRecord::Base
  attr_accessible :fb_id
  has_many :kaszas
  has_many :pictures, :through => :kaszas
end
