class Post < ActiveRecord::Base

  belongs_to :user

  has_many :votes
  has_many :reviews

  validates :title, presence: true, length: { maximum: 50 }
  validates :author, presence: true, length: { maximum: 50 }
  validate :url, :check_url

  def check_url
    unless url.empty? || (url =~ /http.+\.\D+/)
      errors[:url] = 'is invalid'
    end
  end

end