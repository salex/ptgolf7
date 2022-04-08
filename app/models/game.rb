class Game < ApplicationRecord
  belongs_to :group
  has_many :scored_rounds
  has_many :rounds, dependent: :destroy
  has_many :players, through: :rounds

  serialize :stats, Hash

  before_save :set_player_teams

  attribute :state

  serialize :par3, JSON
  serialize :skins, JSON

  def set_stats
    self.stats = {
      round: {}
    }.with_indifferent_access
  end

  def namespace_url(action = nil)
    "/games/#{status.downcase}/#{id}/#{action if action.present?}"
  end


  def game_group
    Current.group || group
  end

  def set_player_teams
    set_stats if stats.blank?
    rnds = rounds.size
    if rnds.positive?
      arr = rounds.pluck(:id, :team)
      teams = arr.pluck(1).sort.uniq
      stats[:round][:players] = arr.size
      stats[:round][:teams] = teams.size
    else
      stats[:round][:players] = 0
      stats[:round][:teams] = 0
    end
  end

  def has_skins?
    skins.present? && skins['good'].present?
  end

  def has_par3?
    par3.present? && par3['good'].present?
  end

  def active_players
    group.active_players.where.not(id: players.pluck(:id))
  end

  def xactive_players
    group.active_players.where_assoc_not_exists(:rounds ,game_id: self.id)
  end

  def inactive_players
    group.inactive_players.where.not(id: players.pluck(:id))
  end

  def expired_players
    group.expired_players.where.not(id: players.pluck(:id))
  end

  def participants
    rounds.includes(:player)
  end

  def current_players
    participants.order('players.rquota DESC')
  end

  def current_team_players
    participants.order(:team, 'players.rquota DESC')
  end

  def current_players_name
    participants.order('players.name')
  end

  def set_state
    # called from scheduled or pending to help manage actions
    rnds = participants
    self.state = {
      players: rnds.size
    }.with_indifferent_access
    if state[:players].positive?
      state[:teams] = rnds.pluck(:team).uniq.sort
      state[:indiv_teams] = state[:teams].size == state[:players]
      state[:has_zero_team] =  state[:teams].include?(0)
      state[:has_scored_round] = rnds.where(type: 'ScoredRound').size.positive?
      state[:can_form] = (state[:teams] == [0]) || status == 'Scheduled'
      state[:can_reform] = !state[:can_form] && state[:has_zero_team]
      state[:can_delete] = (status != 'Scored') && ((Date.today - date) >= 2)
      state[:pot] = game_group.dues * state[:players]
      state[:side] = state[:pot] / 3
    end
    state
  end

  def update_participants(params)
    add_players(params[:add_players]) if params[:add_players].present?
    delete_players(params[:deleted]) if params[:deleted].present?
    check_tee_change(params[:tee]) if params[:tee].present?
    set_state 
    save
  end

  def add_players(add_players)
    add_players.each do |pid|
      player = game_group.players.find(pid)
      grnd = rounds.find_or_initialize_by(player_id: pid)
      grnd.date = date
      grnd.quota = player.quota
      grnd.tee = player.tee
      grnd.team = 0
      grnd.limited = player.limited  # there was a bug called limited? which return boolean
      grnd.save
    end
  end

  def delete_players(deleted_player)
    deleted_player.each do |pid|
      grnd = rounds.find_by(id: pid)
      next unless grnd.present?
      grnd.delete
    end
  end

  def check_tee_change(tees)
    tees.each do |t|
      rid, otee, ntee = t.split('.')
      next if otee == ntee

      r = rounds.find_by(id: rid)
      r.tee = ntee
      nquota =  PlayerObjects::Quota.new(r.player).tee_quota(ntee).to_o
      r.quota = nquota.quota
      r.limited = nquota.limited
      r.save
    end
  end

  def players_quality_stats
    stats = {}
    players.includes(:group).each do |gp|
      stats[gp.id] = gp.quality_stats[:quality]
    end
    stats.sort_by { |_k, v| v[5] }.to_h
  end

  def adjust_teams(params)
    # THIS NEEDS REFACTORED (I did)
    if params[:swap_team_1].present? && params[:swap_team_2].present?
      return swap_team_order(params[:swap_team_1], params[:swap_team_2])
      # swap teams is all that is on form, just rutern if thats all
    end

    if params[:team].present?
      params[:team].each do |player, team|
        # was game_rounnds but was scroed by mistake, change to rounds
        rnd = rounds.find_by(id: player)
        if rnd.present? && rnd.team != team.to_i
          rnd.team = team
          rnd.save
        end
      end
    end
    # can also have tee and delete params so
    update_participants(params)
  end

  def event_teams(team = nil)
    teams = rounds.pluck(:team).uniq.sort
    stats = {}
    if team.present?
      stats[team.to_i] = rounds.where(team: team)
    else
      teams.each do |t|
        stats[t] = current_team_players.where(team: t)
      end
    end
    stats
  end

  def swap_team_order(team1, team2)
    t1 = rounds.where(team: team1)
    t2 = rounds.where(team: team2)
    ok = t1.present? && t2.present?
    if ok
      t1.each { |r| r.update(team: team2) }
      t2.each { |r| r.update(team: team1) }
    end
    ok
  end

  def game_teams(team = nil)
    teams = rounds.pluck(:team).uniq.sort
    stats = {}
    if team.present?
      stats[team.to_i] = current_players.where(team: team)
    else
      teams.each do |t|
        stats[t] = current_players.where(team: t)
      end
    end
    stats
  end

  def pay_skins=(params)
    return if params[:skins][:good].blank?
    new_skins = { 'good' => params[:skins][:good], 'player_par' => {} }
    params[:skins][:in].each_key do |id|
      new_skins['player_par'][id] = params[:skins][:player_par][id]
    end
    stats[:skins] = new_skins
    self.skins = new_skins
    #call skins with game not saved but modifed
    # new copy of rounds will be fetched but noting in them used except name
    side = GameObjects::Skins.new(self)
    side.pay_winners
    save
  end

  def pay_par3s=(params)
    new_par3 = { 'good' => params[:par3][:good], 'player_good' => {} }
    if params[:par3][:in].blank?
      # semi delete skins
      stats[:par3] = new_par3
      self.par3 = new_par3
      self.save 
      return 
    end

    params[:par3][:in].each_key do |id|
      new_par3['player_good'][id] = ''
    end
    new_par3['good'].each do |hole, pid|
      if new_par3['player_good'][pid]
        new_par3['player_good'][pid] += hole
      else
        new_par3['good'].delete(hole)
      end
    end
    stats[:par3] = new_par3
    self.par3 = new_par3
    side = GameObjects::Par3.new(self)
    side.pay_winners
    save
  end

end
