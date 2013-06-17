class ActsAsTaggableOn < ActiveRecord::Migration
  def up
    create_table :tags
  end

  def down
    create_table :taggings
  end
end
