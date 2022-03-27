class AddPlayerIdToPosts < ActiveRecord::Migration[7.0]
  def change
    # add_reference :posts, :player, null: false, foreign_key: true
    add_column :posts, :player_id, :integer
    add_foreign_key :posts, :players

  end
end
