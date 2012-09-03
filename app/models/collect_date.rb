class CollectDate < ActiveRecord::Base
  belongs_to :area
  belongs_to :category
  validates_presence_of :area_id
  validates_presence_of :category_id
  validates_presence_of :collect_date
  validates_uniqueness_of :collect_date, :scope => [:area_id, :category_id]
end
