class GameObjects::Skins
  attr_accessor :game, :rounds, :score, :good, :default_in,:player_par, :winners, :in_skins, :stats
  attr_accessor :skins_obj

  def initialize(game)
    @game = game
    @group = Current.group || game.group
    @default_in = @group.default_in_sidegames.to_s

    set_and_score_skins
  end

  def in_skins?(pid)
    return false if in_skins.blank?

    in_skins.include?(pid) || in_skins.include?(pid.to_s)
  end

  def pay_winners
    # # method outside of new attributes
    # round_ids = rounds.pluck(:id)
    rounds.each do |player|
      # clear round.skins in case it was a rescore
      player.skins = in_skins?(player.id) ? 0.0 : nil
    end
    pay_winning_players unless good.blank?

    rounds.each { |r| r.save if r.skins_changed? }
  end

  private

  def game_rounds
    game_rounds = game.current_players_name
    game_rounds.each { |rnd| rnd.player_name = rnd.name }
    game_rounds
  end

  def set_and_score_skins
    @rounds = game_rounds
    @round_index = rounds.map(&:id)
    game.skins = { 'good': '..................', 'player_par': {} } if game.skins.blank?
    @skins_obj = game.skins
    @player_par = skins_obj['player_par']
    set_skins_attributes
    # game.skins = {'good'=> good, 'player_good' => skins_obj['player_par']}

  end

  def set_skins_attributes
    score_skins
    set_skins_stats
  end

  def score_skins
    @score = {}.with_indifferent_access
    @good = '000000000000000000'
    @winners = Array.new(18, nil)
    @in_skins = []
    pidx = -1
    return if skins_obj['player_par'].blank?

    skins_obj['player_par'].each do |player, par|
      in_skins << player
      score[player] =
        par.gsub(/[BEAPODT]/, 'B' => 1, 'E' => 2, 'A' => 3, 'P' => '.', 'O' => '.', 'D' => '.', 'T' => '.')
      pidx += 1
      0.upto(17) do |hole|
        gscore = good[hole]
        hole_score = score[player][hole]
        next if hole_score == '.'

        if hole_score > gscore
          @winners[hole] = [player, hole_score.to_i]
          good[hole] = hole_score # curr winner or 0
          next
        end
        if hole_score == gscore # cut
          @winners[hole] = nil
          good[hole] = '9'
        end
      end
    end
    good.gsub!(/0/, '.') # replace non-skins 0 with dot
  end

  def set_skins_stats
    @stats = {}.with_indifferent_access
    stats[:in] = in_skins.size
    stats[:dues] = (@group.skins_dues ||= 2).to_f
    stats[:pot] = stats[:dues] * stats[:in]
    stats[:won] = good.count('123')
    if stats['won'].positive?
      stats['each'] =
        ApplicationController.helpers.to_nickels(stats['pot'] / stats['won'], true)
    end
    stats[:cut] = (good.count('0') + good.count('9'))

    wh = {}
    @winners.each_with_index do |who, hole_idx|
      wh[hole_idx + 1] = [who[0], stats[:each], player_name(who[0])] unless who.nil?
    end
    stats[:winners] = wh
    @winners = wh
    stats[:birdies] = good.count('1')
    stats[:eagles] = good.count('2')
    stats[:albatro] = good.count('3')
    stats
  end

  def player_name(pid)
    who = rounds.find_index { |i| i.id == pid.to_i }
    rounds[who].player_name
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
    if @rounds[who].skins.nil?
      @rounds[who].skins = amt
    else
      @rounds[who].skins += amt
    end
  end

end
