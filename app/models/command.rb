class Command < ActiveRecord::Base
  attr_accessible :content, :fb_id, :fb_name, :picture_id
end
