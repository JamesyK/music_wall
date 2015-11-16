class Post < ActiveRecord::Base

  validates :title, presence: true
  validates :author, presence: true
  validate :url, :check_url

  def check_url
    unless url.empty? || (url =~ /http.+\.\D+/)
      errors[:url] = 'is invalid'
    end
  end

end