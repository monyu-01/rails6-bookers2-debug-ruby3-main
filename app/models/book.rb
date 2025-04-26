class Book < ApplicationRecord
  belongs_to :user
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
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
