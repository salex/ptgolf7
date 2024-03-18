# A replacement from the old Quota and Limit classes That can be used from various methods

# player_summary or get gets an object of all tees the player has used and a base quote. The oject (hash).
#  its primary use is in displaying a players quoata summary.

# tee_quota_obj(tee=nil) return a open strut objest with the same information for a single tee.
# It is also used if a player plays from a new tee the first time

# tee_quota(tee=nil) retuns a hash of all tee/limit information
# the object has these keys/attributes
#  { tee:, quota:, limited:,last_played:,totals:,dropped, raw_quota}

# app/services/player_quota.rb
class PlayerObjects::Quota < ApplicationService
  attr_reader :player, :group, :scored_rounds 
  attr_accessor :player_quota, :raw_quota, :last_played, :dropped, :totals, :limited

  def initialize(player)
    @player = player
    @group = Current.group || player.group
    @scored_rounds = @player.scored_rounds
  end

  def get
    player_summary
  end

  def summary
    player_summary
  end

  def tee_quota(tee = nil)
    tee = player.tee if tee.blank?
    tee == 'Base' ? player_base_quota : player_tee_quota(tee)
    if player_quota.present? # @player_quota set in above call
      { tee: tee,
        quota: player_quota,
        limited: limited,
        last_played: last_played,
        totals: totals,
        dropped: dropped,
        rquota: raw_quota,
        name: player.name }.with_indifferent_access
    else
      { tee: tee,
        quota: player.quota,
        limited: PlayerObjects::LimitStatus.get(player, tee),
        last_played: player.last_played,
        totals: [],
        dropped: nil,
        rquota: player.quota.to_f,
        name: player.name }.with_indifferent_access
    end
  end

  def quota(tee=nil)
    #players current quota
    player_tee_quota(tee) || player.quota
  end

  def base_quota
    player_base_quota || player.quota
  end

  private


  def set_attr
    @dropped = @totals = @last_played = @player_quota = @raw_quota = nil
  end

  def player_summary
    results = {}
    # get results for each tee on record
    tees = @scored_rounds.select(:tee).distinct.pluck(:tee).sort

    tees.each do |t|
      player_tee_quota(t)
      unless player_quota.blank?
        results[t] = { tee: t, quota: player_quota, limited: limited, last_played: last_played, totals: totals,
                       dropped: dropped, raw_quota: raw_quota }
      end
    end

    # now get overall base quota for player, regardless of group or tee
    player_base_quota
    results['Base'] = { tee: 'Base', quota: @player_quota, limited: @limited, last_played: @last_played, totals: @totals,
                        dropped: @dropped }
    results
  end

  def player_tee_quota(tee = nil)
    set_attr
    tee = player.tee if tee.blank?
    rounds = player_rounds(tee)
    @player_quota = compute_quota unless rounds.blank?
  end

  def player_base_quota
    set_attr
    rounds = player_rounds
    @player_quota = compute_quota unless rounds.blank?
  end

  def player_rounds(tee = nil)
    if tee.present?
      rounds = @scored_rounds.where(tee: tee).order(:date).reverse_order.limit(group.rounds_used + 1)
    else
      # this was an old feature where a player was duplicated in another group by pin]
        # pins = Player.where(pin: player.pin).pluck(:id)
        # rounds = ScoredRound.where(player_id: pins).order(:date).reverse_order.limit(group.rounds_used + 1)
      rounds = @scored_rounds.order(:date).reverse_order.limit(group.rounds_used + 1)
    end
    return nil if rounds.blank? # a player with no rounds, assume its stored quota
    # reinstitute sanitize_first_round setting - lost in some update
    @first_round = rounds[0] if rounds.size == 1 && group.sanitize_first_round
    @totals = rounds.pluck(:total)
    @dropped = @totals.length > group.rounds_used ? @totals.pop : nil
    # dropped pop the (rounds_used + 1), remaining used used to compute quota
    @limited = PlayerObjects::LimitStatus.get(player, tee)
    @last_played = rounds.maximum(:date)
  end

  def compute_quota
    # force totals sum to float so we can round it
    totals_sum = totals.sum.to_f
    divisor = totals.length
    # throw out high and low points pulled if hi lo rule is true
    # sane being you have to have rounds_used set to at least 6 rounds and
    # you totals count has to be greater than half the rounds_used + 1
    # if rounds_used is 6, you have to have more than (6/2.0)+1 = 4 round, or 5 or 6 rounds
    if group.use_hi_lo_rule && (group.rounds_used > 5) && (totals.length > (group.rounds_used / 2.0) + 1)
      totals_sum = totals_sum - totals.max - totals.min
      divisor -= 2
    end
    if @first_round.present?
      @raw_quota = ((totals_sum + @first_round.quota)/2).round(2)
      # puts "GOT A sanitize_first_round Q #{@first_round.quota} RQ #{@raw_quota}"
    else
      @raw_quota = (totals_sum / divisor).round(2)
    end
    rounding = group.truncate_quota ? 0.0 : 0.5
    (@raw_quota + rounding).to_i
  end
end
