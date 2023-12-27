class PointGolfer < ApplicationRecord
  has_many :inquiries, as: :stashable
  has_many :notices, as: :stashable


  def clubs
    Club.all
  end

  def groups
    Group.all 
  end

  def update_group_settings
    groups.each do |g|
      g.settings['score_place_perc'] = 40 if g.id == 4
      puts g.score_place_dist
      puts g.score_place_perc
      g.preferences = {}
      g.save

    end
  end


  # rails generate model stash stashable:references{polymorphic}:index type:index date:date hash_data:text text_data:text slim:text date_data:date status
end
