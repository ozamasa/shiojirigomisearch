class CollectDate < ActiveRecord::Base
  belongs_to :area
  belongs_to :category_group
  validates_presence_of :area_id
  validates_presence_of :collect_date
  validates_uniqueness_of :collect_date, :scope => [:area_id]
end
