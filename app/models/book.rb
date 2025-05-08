class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  scope :created_today, -> { where(created_at: Time.zone.now.all_day) } 
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) } 
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) } 
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) } 

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  after_create do
    user.followers.each do |follower|
      notifications.create(user_id: follower.id, notifiable_type: "Book", notifiable_id: id)
    end
  end

  def self.search_for(word, how)
    case how
    when 'perfect'
      where(title: word)
    when 'forward'
      where('title LIKE ?', "#{word}%")
    when 'backward'
      where('title LIKE ?', "%#{word}")
    when 'partial'
      where('title LIKE ?', "%#{word}%")
    end
  end
end
