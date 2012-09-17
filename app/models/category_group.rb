class CategoryGroup < ActiveRecord::Base
  has_many :category
  validates_presence_of :name
end
