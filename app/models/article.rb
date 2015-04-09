class Article < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates_presence_of :user_id, :title, :excerpt, :content
end
