class Like < ActiveRecord::Base
  attr_accessible :doc_id, :doc_type, :user_id

  belongs_to :doc, :polymorphic => true
  has_one :feed_item, :as => :doc, :dependent => :destroy

end
