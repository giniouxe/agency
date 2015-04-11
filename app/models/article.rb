class Article < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates_presence_of :user_id, :title, :content
  validates :excerpt, presence: true, length: { maximum: 350 }
end
