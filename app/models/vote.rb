class Vote < ActiveRecord::Base

  belongs_to :user
  belongs_to :post

  # validate user_cannot_vote_twice:

  # def user_cannot_vote_twice
  #   vote_for_animal = self.post.votes.find_by(user_id: self.user_id)
  # end

end