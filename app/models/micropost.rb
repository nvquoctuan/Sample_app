class Micropost < ApplicationRecord
  MICROPOST_TYPE = %i(content picture)
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.size.s_140}
  validate :picture_size

  scope :recent_posts, ->{order created_at: :desc}
  scope :feed, ->(id){where(user_id: id)}

  mount_uploader :picture, PictureUploader

  private
  def picture_size
    errors.add(:picture, t(".to_big")) if picture.size > Settings.size.s_5.megabytes
  end
end
