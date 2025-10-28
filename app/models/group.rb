class Group < ApplicationRecord
  belongs_to :club
  has_many :players, :dependent => :destroy
  has_many :games, :dependent => :destroy
  has_many :rounds, through: :games
  has_many :users, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  validates :name, presence: true, :uniqueness => {:scope => [:club_id, :name]}
  validates :club_id, presence: true

  # remove after settings set
  serialize :settings, coder: YAML, type: ActiveSupport::HashWithIndifferentAccess
  serialize :preferences, coder: JSON

  after_initialize :set_attributes


  # lets just set all attributes to settings values 
  # will be cast to class if coming from form update
  # if you add/remove a setting, add/remove an attribute with class and add to default settings 

  attribute :par_in, :string, default: "444444444"
  attribute :par_out, :string, default: "444444444"
  attribute :welcome, :text, default: "Welcome to the #{self.name}"
  attribute :alert, :text, default: ""
  attribute :notice, :text, default: ""
  attribute :tee_time, :string
  attribute :play_days, :string
  attribute :dues, :integer
  attribute :skins_dues, :integer
  attribute :par3_dues, :integer
  attribute :other_dues, :integer
  attribute :truncate_quota, :boolean
  attribute :pay, :string
  attribute :limit_new_player, :boolean
  attribute :limit_rounds, :integer
  attribute :limit_points, :integer
  attribute :limit_new_tee, :boolean
  attribute :limit_new_tee_rounds, :integer
  attribute :limit_new_tee_points, :integer
  attribute :limit_frozen_player, :boolean
  attribute :limit_frozen_points, :integer
  attribute :limit_inactive_player, :boolean
  attribute :limit_inactive_days, :integer
  attribute :limit_inactive_rounds, :integer
  attribute :limit_inactive_points, :integer
  attribute :sanitize_first_round, :boolean
  attribute :trim_months, :integer
  attribute :rounds_used, :integer
  attribute :use_hi_lo_rule, :boolean
  attribute :default_stats_rounds, :integer
  attribute :use_keyboard_scoring, :boolean
  attribute :default_in_sidegames, :boolean
  attribute :use_autoscroll, :boolean
  attribute :score_place_dist, :string
  attribute :score_place_perc, :integer
  attribute :active_player_days, :integer



  def set_attributes
    if self.settings.blank?
      # new record, set settings from default options
      self.settings = self.default_settings
    elsif self.settings.keys != self.default_settings.keys 
      # sync settings - add new key/value, delete old keys"
      self.default_settings.each do |k,v|
        if !self.settings.has_key?(k)
          settings[k] = v
        end
      end
      self.settings.each do |k,v|
        if !self.default_settings.has_key?(k)
          settings.delete(k)
        end
      end
      self.save
    end

    self.settings.each do |k,v|
      # set attributes to settings
      self.send("#{k.to_sym}=", v)
    end
  end

  
  def default_settings
    # default settings control valid setting
    # if you add or remove a key
    #   add or remove the attribute
    # only used on new/create and for its keys which point to an attribute
    {
      par_in:'444444444',
      par_out:'444444444',
      welcome:"Welcome to #{self.name}",
      alert:'',
      notice:'',
      tee_time:'9:30am',
      play_days:'m w f',
      dues:6,
      skins_dues: 2,
      par3_dues: 2,
      other_dues: 0,
      truncate_quota:true,
      pay:'',
      limit_new_player:false,
      limit_rounds:2,
      limit_points:2,
      limit_new_tee:false,
      limit_new_tee_rounds:1,
      limit_new_tee_points:2,
      limit_frozen_player:false,
      limit_frozen_points:2,
      limit_inactive_player:false,
      limit_inactive_days:180,
      limit_inactive_rounds:1,
      limit_inactive_points:2,
      sanitize_first_round:false,
      trim_months:18,
      rounds_used:10,
      use_hi_lo_rule:false,
      default_stats_rounds:100,
      use_keyboard_scoring:false,
      default_in_sidegames:true,
      use_autoscroll:true,
      score_place_dist:'mid',
      score_place_perc:50,
      active_player_days:90
    }.with_indifferent_access  
  end

  def update_group(params)
    self.assign_attributes(params)
    # updates record withou saving, just set attributes
    self.default_settings.each do |k,v|
      # now take the set attributes and update to serialized settings
      self.settings[k] = self.send(k.to_sym) 
    end
    self.save 
  end


  def expired_players
    self.players.where_assoc_not_exists(:rounds).order(:name)
  end

  def active_players(ago=self.active_player_days)
    active_date = Date.today - ago.days
    active = self.players.where_assoc_exists(:rounds).where(Player.arel_table[:last_played].gteq(active_date)).or(new_players).order(:name)
  end

  def inactive_players(ago=90)
    active_date = Date.today - ago.days
    inactive = self.players.where_assoc_exists(:rounds).where(Player.arel_table[:last_played].lt(active_date)).order(:name)
  end

  def new_players
    self.players.where(last_played:Date.today).where_assoc_not_exists(:rounds)
  end


  def players_by_status(ago=90)
    return expired_players,active_players(ago),inactive_players(ago)
  end

  def auto_search(params)
    n = params[:input]
    t = Player.arel_table
    player_ids = self.players.where(t[:first_name].matches("%#{n}%"))
    .or(self.players.where(t[:last_name].matches("%#{n}%")))
    .or(self.players.where(t[:nickname].matches("%#{n}%"))).order(:name).pluck(:name,:id)
  end

  def home_events
    self.games.where(status:%w(Scheduled Pending)).order(:date).reverse_order
  end

  def quota_summary
    summary = {active:get_status_summary(active_players), inactive:get_status_summary(inactive_players)}
  end

  def get_status_summary(group_players)
    summary = []
    group_players.each do |gp|
      summary <<  PlayerObjects::Quota.new(gp).tee_quota
    end
    summary
  end
  
  def group_color
    %w{green red blue orange}[self.id % 4]
  end

  def recompute_group_quotas
    # quotas = Quotas.new(self)
    self.players.each do |player|
      player.recompute_quota
    end
  end

  def trim_rounds
    # lets get rid of all rounds and events that are over options[:trim_months] months old
    exp_date = Date.today - self.trim_months.months
    games = self.games.where(Game.arel_table[:date].lt(exp_date)).includes(:rounds)
    if games.present?
      games.destroy_all
      recompute_group_quotas
    end
  end

  def options
    # just an alias for settings, setting, et
    self.settings
  end

  # a bunch of one-liners that answer a question
  def truncate_quota?
     self.truncate_quota
  end

  def pays
    self.pay.include?('places') ? 'places' : 'sides'
  end

  def pays_sides?
    pays == 'sides'
  end

  def pays_places?
    pays == 'places'
  end

  def rounding
    truncate_quota? ? 0 : 0.5
  end

  def limit_new_player?
    (self.limit_new_player)
  end

  def sanitize_first_round?
    (self.sanitize_first_round)
  end

  def round_limit
    limit_new_player? ? self.limit_rounds.to_i : 0
  end

  def point_limit
    self.limit_points.to_i
  end

end
