class Kasza < ActiveRecord::Base
  attr_accessible :account_id, :picture_id
  belongs_to :account
  belongs_to :picture
end
