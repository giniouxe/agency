class Comment < ActiveRecord::Base
  belongs_to :article

  validates_presence_of :article_id
  validates :author, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 500 }
end
