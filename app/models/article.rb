class Article < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates_presence_of :user_id, :title, :content
  validates :excerpt, presence: true, length: { maximum: 350 }
  validate :picture_size

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, 'Picture should be les than 5 MB')
      end
    end
end
