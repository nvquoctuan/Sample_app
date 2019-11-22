class Micropost < ApplicationRecord
  MICROPOST_TYPE = %i(content picture).freeze
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.size.s_140}
  validate :picture_size

  scope :recent_posts, ->{order created_at: :desc}
  scope :feed, ->(user){where("user_id IN (?) OR user_id = ?",
                        user.followers.ids, user.id)}

  has_one_attached :picture
  delegate :name, to: :user, prefix: true

  private

  def picture_size
    return unless picture.attached?
    return unless picture.blob.byte_size > Settings.size.s_5.megabytes

    errors.add(:picture, t(".to_big"))
    picture.purge
  end
end
