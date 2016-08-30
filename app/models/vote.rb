class Vote < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :voteable, polymorphic: true

  validates_uniqueness_of :user, scope: [:voteable_id, :voteable_type]
end
