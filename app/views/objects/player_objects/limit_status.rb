=begin
  Limits is an extention to Groups and stored in Group.settings

  Limiting defines serveral status that will limit the number of PlusMinus points will be used
  to in scoring a team (or indiviual team). Groups are usually unsure that a new players declared 
  handicap or points quota is correct. If a player declares 18 points, and pulls 28. Their quota 
  be set to 28 after the round is scored, but on a portion of their poinst will be used in decided 
  what teams won. Limiting it completly optional but there are 4 options. All options define how
  many rounds the limit status will be in effect, and how many plus/minus points will be used. 
  Status are checked in the folloiwing order:

    Limit_frozen_player. You can set a players frozen attribute to true (someone who does not
    play very often and is inconsistant)

    Limit_new_player.

    Limir_new_tee. A player decides to move up or down to a new tee. Either by setting tee in players
    record or setting different tee in round.

    Limit_inactive_player. If a player has not played in a set number of days.

  The service will return either a status "LimitPM:Reason" string or nil if not limited

  The status is stored the the game.round when created but is alse used  anywhere a 
  quota is displayed

=end


class PlayerObjects::LimitStatus < ApplicationService
  attr_reader :player, :tee, :group
  
  def initialize(player,tee = nil)
    @player = player
    @tee = tee || player.tee
    @group = Current.group || player.group
  end

  def get
    get_limit_status
  end

  private

  def get_limit_status

    if group.limit_frozen_player && player.is_frozen
      return "#{group.limit_frozen_points}:frozen"
    end
    
    if group.limit_new_player
      unless scored_rounds_count >= group.limit_rounds
        return "#{group.limit_points}:newPlayer"
      end
    end

    if group.limit_new_tee
      unless scored_rounds_count(tee) >= group.limit_new_tee_rounds
        return "#{group.limit_new_tee_points}:newtee"
      end
    end

    if group.limit_inactive_player
      limit_date = (Date.today - group.limit_inactive_days)
      rounds_count = player.scored_rounds.where("rounds.date > ?",limit_date).size
      unless rounds_count >= group.limit_inactive_rounds
        return "#{group.limit_inactive_points}:inactive"
      end
    end
    
    return nil
  end

  def scored_rounds_count(atee = nil)
    if atee.present?
      player.scored_rounds.where(tee:atee).size
    else
      player.scored_rounds.size
    end
  end

end
