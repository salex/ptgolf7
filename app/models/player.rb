class Player < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :group
  has_one :user
  has_many :scored_rounds
  has_many :rounds, dependent: :destroy
  validates :tee, presence: true
  before_save :set_name
  after_save :check_tee
  validates :quota, presence: true,:numericality => {only_integer: true}
  before_validation :fix_name
  before_validation :unformat_phone
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :name, :uniqueness => {:scope => [:group_id, :name]}

  before_create :set_new_defaults

  def self.pairing_search(params,numb=30)
    subject = Player.find_by(id:params[:subject])
    return false if subject.blank?
    sname = subject.name
    mname = []
    marray = []
    subject_rounds = subject.scored_rounds.order(date: :desc).limit(numb).pluck(:game_id,:team,:date)
    results = {subject:sname,mates:[],mname:[]}.with_indifferent_access
    params[:mates].each do |m|
      mate = Player.find(m)
      results[:mname] << mate.name
      m_rounds = mate.scored_rounds.order(date: :desc).limit(numb).pluck(:game_id,:team,:date)
      intersection = subject_rounds & m_rounds
      results[:mates] << intersection
    end
    return results
  end

  def full_name
    self.name
  end

  def name_group
    self.name + " - #{self.group.name}"
  end

  def set_new_defaults
    self.rquota = self.quota if self.rquota.nil?
    self.pin = Player.maximum(:pin) + 1 if self.pin.nil?
  end

  def set_name
    if use_nickname && self.nickname.present?
      self.name = "#{nickname} - #{first_name[0]} #{last_name}"
    else
      self.name = "#{first_name} #{last_name}"
    end
  end

  def check_tee
    # if player primary tee changed or permanent is_frozen is set, recompute quota
    # recompute quota will set limited status to frozen or nil based on is_frozen
    # if is_frozen not changed, will just recompute quota.
    if self.saved_change_to_tee? || self.saved_change_to_is_frozen?
      self.recompute_quota
      puts "IT TWAS FIRED, WHAT'S NEXT"
    end
  end

  def fix_name
    # remove any leading/trailing spaces, conversion have nil nickname
    if self.nickname.present?
      self.nickname.strip!
    else
      self.nickname = ''
    end
    first = self.first_name.strip
    last = self.last_name.strip
    # get rid of all caps
    first = first.titlecase if first == first.upcase && first.length > 2
    last = last.titlecase if last == last.upcase
    #set to titlecase unless mixed cases in let_alone?
    self.first_name = let_alone?(first) ? first : first.titlecase
    self.last_name = let_alone?(last) ? last : last.titlecase
    set_name
  end

  def let_alone?(str)
    char1 = str[0..0]
    rest = str[1..-1]
    initials = str.length == 2
    # let name starting with upercase, then lowercase, than any other uppercase alone (LaPoint)
    upper_alone = char1.match(/[A-Z]/).present? && rest.match(/[a-z]/).present? && rest.match(/[A-Z]/).present?
    # let name starting with lowercase and having any uppercase alone (daHammer)
    lower_alone = char1.match(/[a-z]/).present? && rest.match(/[A-Z]/).present? 
    return upper_alone || lower_alone || initials
  end

  def format_phone
    number_to_phone(self.phone,delimiter:'.') if self.phone.present?
  end

  def unformat_phone
    self.phone = self.phone.gsub(/[^\d]/,"") if self.phone.present?
  end

  def quality_stats(limit=100)
    #TODO should be based on group stats setting
    grp = self.group
    soy = Date.today.beginning_of_year
    sr = self.scored_rounds.where(ScoredRound.arel_table[:date].gteq(soy))
    qs = {}
    [:quality,:skins,:par3,:other].each do |what|
      rnds = sr.where.not(what => nil) #.order(:date).reverse_order
      qs[what] = method_stats(what,rnds,grp)
    end
    qs
  end

  def pt_rank(limit_rounds=180)
    grp = Current.group || self.group
    sr = self.scored_rounds.where.not(quality:nil).order(:date).reverse_order.limit(limit_rounds)
    number_rounds = sr.size
    won = sr.pluck(:quality).sum
    dues = grp.dues * number_rounds
    balance = (won - dues).round(2)
    perc = dues > 0 ? (number_rounds * won / dues).round(3) : 0.0
    avg =  number_rounds > 0 ? (won / number_rounds).round(2) : 0.0
    [self.name,number_rounds,won,dues,balance,perc,avg]

  end

  def method_stats(method,rounds,grp)
    # rounds = sr.where.not(method => nil)
    number_rounds = rounds.size
    won = rounds.pluck(method).sum
    if method == :quality
      dues = grp.dues * number_rounds
    else
      dues = grp.send("#{method.to_s}_dues") * number_rounds
    end
    balance = (won - dues).round(2)
    perc = dues > 0 ? (number_rounds * won / dues).round(3) : 0.0
    avg =  number_rounds > 0 ? (won / number_rounds).round(2) : 0.0
    [self.name,number_rounds,won,dues,balance,perc,avg]
  end

  def recompute_quota(game_date = nil)
    # game_date is only set if coming from Games::ScoreRounds, pass on to set_quota
    quotas = PlayerObjects::Quota.new(self).tee_quota.to_o
    set_quota(quotas, game_date)
  end

  def set_quota(quotas, game_date)
    if quotas.totals.blank?
      # get base quota. will set player.quota if there are rounds
      quotas = PlayerObjects::Quota.new(self).tee_quota('Base').to_o 
    end
    # remembers there is no tee set, uses primary tee
    #TODO is there any reason for this if statement? If nothing changed should not do anything
    # if quotas.totals.present? || game_date.present? || quotas.tee == "Base"
      # update last_played if game_date && played from different tee
    self.quota = quotas.quota
    self.last_played = game_date.present? && game_date > self.last_played ? game_date : quotas.last_played
    self.rquota = quotas.rquota
    self.limited = quotas.limited
    # will rollback if quota.nii?
    self.save if self.changed?
    # end
  end

  def quota_limited
    if limited?
      "<strong>#{self.quota}*</strong>".html_safe
    else
      quota
    end
  end
  def rquota_limited
    if limited?
      "<strong>#{self.rquota}*</strong>".html_safe
    else
      rquota
    end
  end

  def limited?(tee=nil)
    tee.blank? ? self.limited.present? : PlayerObjects::LimitStatus.get(self,tee)
  end

end
