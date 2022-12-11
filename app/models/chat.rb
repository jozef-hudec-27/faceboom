class Chat < ApplicationRecord
  validates_uniqueness_of :key

  def self.between(user1, user2)
    user_a, user_b = *[user1, user2].sort_by { |user| user.id }
    key = "#{user_a.id}u#{user_b.id}u"
    self.find_by key: key
  end
  
  def users
    user_a = User.find_by id: key.split('_')[0].split('u')[0]
    user_b = User.find_by id: key.split('_')[1].split('u')[0]
    [user_a, user_b]
  end
end
