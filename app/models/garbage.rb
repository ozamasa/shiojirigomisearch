class Garbage < ActiveRecord::Base
  belongs_to :category
  validates_presence_of :name
  validates_uniqueness_of :image_url, :case_sensitive => false
end
