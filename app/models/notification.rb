class Notification < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  # belongs_to :notifiable, polymorphic: true

  scope :latest, -> { where('created_at > ?', Time.now - 7.days) }
end
