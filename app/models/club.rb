class Club < ApplicationRecord  
  has_many :groups, :dependent => :destroy
  has_many :players, through: :groups
  validates :name, presence: true, uniqueness:true
  before_validation :unformat_phone


  def format_phone
    number_to_phone(self.phone,delimiter:'.') if self.phone.present?
  end

  def unformat_phone
    self.phone = self.phone.gsub(/[^\d]/,"") if self.phone.present?
  end

  def auto_search(params)
    group_h = self.groups.pluck(:id,:name).to_h
    n = params[:input]
    t = Player.arel_table
    player_ids = self.players.where(t[:first_name].matches("%#{n}%"))
    .or(self.players.where(t[:last_name].matches("%#{n}%")))
    .or(self.players.where(t[:nickname].matches("%#{n}%"))).pluck(:name,:id,:group_id)

    player_ids.each do |a|
      a[0] += " - #{group_h[a[2]]}"
    end
    player_ids
  end

  def par3s
    holes = self.par_in + self.par_out
    arr = []
    0.upto(17){|i| arr << i+1 if holes[i] == '3'}
    arr
  end
  
end
