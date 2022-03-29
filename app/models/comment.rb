class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :player
  # broadcasts_to :post

  def can_edit_destroy?
    Current.player.present? && self.player_id == Current.player.id
  end

end
