class Category < ActiveRecord::Base
  belongs_to :category_group
  validates_presence_of :name
  validates_presence_of :category_group_id
end
