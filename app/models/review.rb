class Review < ActiveRecord::Base

  belongs_to :post
  belongs_to :user

  validates :comment, presence: true, length: { in: 1..140 }
  validates :rating, inclusion: { in: 1..5 }
  validate :user_cannot_review_twice

  def user_cannot_review_twice
    if post.reviews.find_by(user_id: user_id)
      errors.add(:reviews, "You can only review a post once")
    end
  end

end