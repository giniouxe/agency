class Article < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates_presence_of :user_id, :title, :content
  validates :excerpt, presence: true, length: { maximum: 350 }
  validate :picture_size

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  has_many :comments, dependent: :destroy

  def tag_list
    tags.collect(&:name).join(', ')
  end

  def tag_list=(tags)
    names = tags.split(',').collect { |n| n.strip.titleize }.uniq
    self.tags = names.collect { |n| Tag.find_or_create_by(name: n) }
  end

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, 'Picture should be les than 5 MB')
      end
    end
end
