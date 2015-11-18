class Vote < ActiveRecord::Base

  belongs_to :user
  belongs_to :post, counter_cache: true

  validate :user_cannot_vote_twice

  def user_cannot_vote_twice
    if post.votes.find_by(user_id: user_id)
      errors.add(:votes, "You can only vote for a post once")
    end
  end

end