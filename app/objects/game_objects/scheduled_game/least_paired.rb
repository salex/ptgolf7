#game_least_paired.rb
class GameObjects::ScheduledGame::LeastPaired
  attr_accessor :game_players,:interactions, :players, :analysis, :ordered_ids, :scheduled_rounds

  def initialize(game)
    @game_players = game.players
    @players = game_players.pluck(:id)
    analyze
    # puts "INTERACTIONS #{interactions.inspect}"
    @ordered_ids = interactions.pluck(0)
    @scheduled_rounds = []
    @ordered_ids.each do |id|
      @scheduled_rounds << game.rounds.find_by(player_id:id)
    end
  end


  def analyze
    rounds = {}
    today = Date.today
    @analysis = {}
    game_players.each do |gp|
      rounds[gp.id] = gp.scored_rounds.where(ScoredRound.arel_table[:date].gteq(today - 120.days)).order(date: :desc).pluck(:game_id,:team,:date)
    end
    players.each do |this_player|
      analysis[this_player] = {}
      players.each do |other_player|
        if other_player != this_player
          played = rounds[this_player] & rounds[other_player]
          played_count = played.count 
          played_last = played.blank? ? 0 : (today - played[0][2]).to_i
          played_score = (played_last * (played_count)) 
          analysis[this_player][other_player] = played_score
        end
      end
    end
    analysis.each do |k,v| 
      ord =v.sort_by{|kk,vv| vv}.reverse.to_h
      analysis[k] = ord
    end
    @interactions = sum_analysis
  end

  def sum_analysis
    interactions = {}
    analysis.each do |k,v|
      interactions[k] = {}
      v.each do |kk,vv|
        interactions[k].blank? ? interactions[k] = vv : interactions[k] += vv
      end
    end
    # puts "INTERACTIONS HASH #{interactions}"
    interactions.sort_by{|k,v| v}.reverse
  end
end