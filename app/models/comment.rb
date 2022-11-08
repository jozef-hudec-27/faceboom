class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true

  def root_post
    if commentable_type == 'Post'
      return commentable
    else
      return commentable.root_post
    end
  end
end
