class User < ActiveRecord::Base
  belongs_to :group
  belongs_to :player

  has_secure_password
  
  validates_presence_of :email
  validates_presence_of :group_id
  validates_uniqueness_of :username, :allow_blank => true, scope: :group_id
  validates_uniqueness_of :email, :case_sensitive => false, scope: :group_id
  # validates :full_name, :uniqueness => {:scope => [:group_id, :nickname]}

  validates_format_of :username, :with => /[-\w\._@]+/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  serialize :role, coder: YAML, class:  Array
  before_save :downcase_login

  def roles
    self.role
  end

  def downcase_login
    self.email.downcase!
    self.username.downcase!
  end

  def to_label
    self.player.present? ? self.player.name : self.email
  end
  alias_method :name, :to_label

  
  def generate_token(column,sa="")  
    begin  
      self[column] = sa + SecureRandom.urlsafe_base64  
    end while User.exists?(column => self[column])  
  end

  # Role checker, from low of scheduler to high of super
  def is_scheduler?
    return has_role?(%w(super coordinator manager scorer scheduler))
  end

  def is_scorer?
    return has_role?(%w(super coordinator manager scorer))
  end

  def is_manager?
    return has_role?(%w(super coordinator manager))
  end
 
  def is_coordinator?
    return has_role?(%w(super coordinator))
  end

  def is_super?
    return has_role?('super')
  end
   
  def has_role?(role)
    # TO DO  Should always be an array or error
    return false if self.roles.nil?
    
    if role.class != Array
      if self.roles.class == Array
        return self.roles.include?(role.to_s.downcase)
      else
        return self.roles == (role.to_s.downcase)
      end
    else
      ok = false
      role.each do |r|
        if self.roles.class == Array
          ok = true if self.roles.include?(r.to_s.downcase)
        else
          ok = true if self.roles == (r.to_s.downcase)
        end
      end
      return ok
    end
  end
end
