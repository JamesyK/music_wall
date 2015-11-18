class User < ActiveRecord::Base

  has_many :posts
  has_many :votes
  has_many :reviews

  validates :username, presence: true, uniqueness: true, length: { in: 4..20 }
  validates :email, presence: true, uniqueness: true, format: { with: /.+\@.+\.\D*/ }
  validates :password, presence: true, length: { in: 6..30 }

end