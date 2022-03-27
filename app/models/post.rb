class Post < ApplicationRecord
  belongs_to :group
  belongs_to :player
  has_many :comments

  def can_edit_destroy?
    Current.player.present? && self.player_id == Current.player.id
  end
end
