class MessageNotification < ApplicationRecord
  belongs_to :message
  belongs_to :receiver, class_name: 'User'
  has_one :sender, through: :message 
end
