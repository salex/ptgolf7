class PointGolfer < ApplicationRecord
  has_many :inquiries, as: :stashable
  has_many :notices, as: :stashable


  def clubs
    Club.all
  end

  def groups
    Group.all 
  end


  # rails generate model stash stashable:references{polymorphic}:index type:index date:date hash_data:text text_data:text slim:text date_data:date status
end
