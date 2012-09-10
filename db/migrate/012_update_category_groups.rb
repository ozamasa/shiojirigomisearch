class UpdateCategoryGroups < ActiveRecord::Migration
  def self.up
    begin
      execute("update category_groups set name = 'プラ製容器包装' where id = 1")
    rescue
    end
  end

  def self.down
  end
end
