class Chat < ApplicationRecord
  has_many :messages

  validates_uniqueness_of :key

  def self.between(user1, user2)
    user_a, user_b = *[user1, user2].sort_by(&:id)
    key = "#{user_a.id}u_#{user_b.id}u"
    find_by key:
  end

  def users
    user_a = User.find_by id: key.split('_')[0].split('u')[0]
    user_b = User.find_by id: key.split('_')[1].split('u')[0]
    [user_a, user_b]
  end
end
