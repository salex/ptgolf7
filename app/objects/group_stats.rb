class GroupStats

  attr_accessor :group
  attr_accessor :players
  attr_accessor :game_options


  def initialize(params=nil)
    @group = Current.group
    @players = group.active_players(120)
    @game_options = money_list_options(params)
  end

  def money_list_options(game_options=nil)
    if game_options.blank?
      game_options = {}.with_indifferent_access
      game_options[:game] = 'quality'
      game_options[:order] = 'won'
      game_options[:limit_by] = 'date'
      game_options[:from] = Date.today.beginning_of_year
      game_options[:limit] = group.default_stats_rounds
    end
    game_options
  end

  def money_list(game)
    list = []
    order_col = {'perc'=>5,'bal' => 4, 'won' => 2,'avg' => 6}
    order = order_col[game_options[:order]]
    players.each do |player|
      list << money_stats(player,game)
    end
    list.sort_by{|l| l[order]}.reverse
  end

  def money_stats(player,game)
    if game_options[:limit_by] == 'rounds'
      sr = player.scored_rounds.where.not(game => nil).order(:date).reverse_order.limit(game_options[:limit])
    else
      sr = player.scored_rounds.where.not(game => nil).where('date >= ?',game_options[:from])
    end
    game_stats(game,sr,player)
  end

  def game_stats(game,rounds,player)
    # rounds = sr.where.not(game => nil)
    number_rounds = rounds.size
    won = rounds.pluck(game).sum
    q = 0.0
    if number_rounds > 0
      q =   rounds.pluck(:quota).sum.to_f / number_rounds
    end
    if game == :quality
      dues = group.dues * number_rounds
    else
      dues = group.send("#{game.to_s}_dues") * number_rounds
    end
    balance = (won - dues).round(2)
    perc = q.round(3)
    # perc = dues > 0 ? (number_rounds * won / dues).round(3) : 0.0
    avg =  number_rounds > 0 ? (won / number_rounds).round(2) : 0.0
    [player.name,number_rounds,won,dues,balance,perc,avg]
  end

end