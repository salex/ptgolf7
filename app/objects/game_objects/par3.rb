
class GameObjects::Par3
  attr_accessor :game, :rounds, :good, :player_good, :winners, :in_par3, :stats, :par3# what is stored in game

  def initialize(game)
    # puts "IN OBJECTS::GAMEOBJECTS::PAR3"
    @game = game
    @group = Current.group || game.group
    # @par3 = {} # start with empty hash
    score_par3
  end

  def in_par3?(pid)
    # pid is really round.id
    return false if in_par3.blank?
    in_par3.include?(pid) || in_par3.include?(pid.to_s)
  end

  def par3_winner?(pid, hole)
    return false if good.blank?
    pid.to_s == good[hole.to_s]
  end

  def pay_winners
    # # method outside of new attributes
    # round_ids = rounds.pluck(:id)
    @rounds.each do |player|
      # clear round.par in case it was a rescore
      player.par3 = in_par3?(player.id) ? 0.0 : nil
    end
    pay_winning_players unless good.blank?
    @rounds.each { |r| r.save if r.par3_changed? }
  end

  def pay_winning_players
    winners.each do |_hole, arr|
      who = arr[0].to_i
      amt = arr[1].to_f
      idx = @round_index.index(who)
      pay_player(idx, amt)
    end
  end

  def pay_player(who, amt)
    if @rounds[who].par3.nil?
      @rounds[who].par3 = amt
    else
      @rounds[who].par3 += amt
    end
  end

  private

  def score_par3
    @rounds = game_rounds
    @round_index = rounds.map(&:id)
    game.par3 = { 'good': {}, 'player_good': {} } if game.par3.blank?
    @good = game.par3['good']
    @player_good = game.par3['player_good']

    # set_good_par3s
    set_par3_attributes
    game.par3 = {'good'=> good, 'player_good' => player_good}
  end

  def game_rounds
    game_rounds = game.current_players_name
    game_rounds.each { |rnd| rnd.player_name = rnd.name }
    game_rounds
  end


  def update_good_players
    good.each do |hole, pid|
      if player_good.key?(pid)
        player_good[pid] += hole.to_s
      else
        good.delete(hole)
      end
    end
  end

  def set_par3_attributes
    @stats = {}
    stats['par3s'] = number_of_par3s
    stats['dues'] = (@group.par3_dues ||= 2).to_f
    set_scores unless good.blank?
  end

  def set_scores
    @in_par3 = player_good.keys
    stats['holes'] = good.to_a.map { |i| i[0] }
    stats['in'] = in_par3.size
    stats['won'] = good.present? ? good.keys.count : 0
    stats['pot'] = stats['dues'] * in_par3.size
    if stats['won'].positive?
      stats['each'] =
        ApplicationController.helpers.to_nickels(stats['pot'] / stats['won'], true)
    end
    @winners = set_winners
  end

  def number_of_par3s
    numb = count_par3s(@group)
    numb ||= count_par3s(@group.club)
    numb || 4
  end

  def count_par3s(klass)
    (klass.par_in + klass.par_out).count('3') if klass.par_in.present? && klass.par_out.present?
  end

  def set_winners
    who_won = {}
    good.each do |hole, who|
      who_won[hole] = [who, stats['each'], player_name(who)]
    end
    who_won
  end

  def player_name(pid)
    who = @rounds.find_index { |i| i.id == pid.to_i }
    @rounds[who].player_name
  end
end
