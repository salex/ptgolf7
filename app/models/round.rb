class Round < ApplicationRecord
  belongs_to :game
  belongs_to :player

  attribute :front_net, :integer
  attribute :back_net, :integer
  attribute :total_net, :integer
  attribute :player_name, :string

  def full_name
    self.player.name
  end
  alias_method :name, :full_name

  def is_scored?
    self.type == 'ScoredRound'
  end

  def nickname
    self.player.nickname
  end
  
  def side_quota
    self.quota / 2.0
  end

  def total_pm
    self.total - self.quota if self.total.present?
  end

  def front_pm
    self.front - side_quota if self.front.present?
  end

  def back_pm
    self.back - side_quota if self.back.present?
  end

  def total_net
    get_net(total,total_pm) if self.total.present?
  end

  def total_net_pm
    total_net - quota if self.total.present?
  end

  def front_net
    get_net(front,front_pm) if self.front.present?
  end

  def front_net_pm
    front_net - side_quota if self.front.present?
  end

  def back_net
    get_net(back,back_pm) if self.back.present?
  end

  def back_net_pm
    back_net - side_quota if self.back.present?
  end

  def limited?
    # The limited field is a string that contains nil or a point limit and reason player limited
    # this just converts it into a boolean
    self.limited.present?
  end

  def point_limit
    if limited?
      self.limited.to_i
    else
      0
    end
  end

  def quota_limited
    if limited?
      "<strong>#{self.quota}*</strong>".html_safe
    else
      quota
    end
  end

  private

  def get_net(pp,pm)
    q = pp - pm
    net = q + pm
    if limited? && pm.abs > point_limit
      if pm.negative?
        net = q - point_limit
      else
        net = q + point_limit
      end
    end
    net
  end

  # def get_limited_net(limit, points_pulled, quota)
    
  #   plus_minus = points_pulled - quota
  #   net = points_pulled
  #   if plus_minus.abs > limit
  #     net =  plus_minus.negative? ? (quota - limit) : (quota + limit)
  #   end
  #   net
  # end


end
