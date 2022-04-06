class Post < ApplicationRecord
  belongs_to :group
  belongs_to :player
  has_many :comments, dependent: :destroy
  validates :title, presence: true
  validates :content, presence: true


  def can_edit_destroy?
    Current.player.present? && self.player_id == Current.player.id
  end
end
