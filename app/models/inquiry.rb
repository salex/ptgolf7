class Inquiry < Stash

  def self.get_new
    Inquiry.where(date:nil)
  end

  def update_inquiry(params)
    self.hash_data= params[:inquiry].to_h
    # puts "DDDDDDD got here??? has date? #{params[:date].present?}"
    if params[:date].present?
      self.date = params[:date]
    end
    is_valid?
  end

  def is_valid?
    ok = true
    if self.hash_data[:name].blank?
      ok = false
      self.errors.add(:name, "is missing")
    end
    if self.hash_data[:email].blank?
      ok = false
      self.errors.add(:email, "is missing")
    end
    if self.hash_data[:phone].blank?
      ok = false
      self.errors.add(:phone, "is missing")
    end
    if self.hash_data[:remarks].blank?
      ok = false
      self.errors.add(:remarks, "is missing")
    end
    z = self.hash_data[:answer].split('|')
    unless z[0] == z[1] && ok
      self.errors.add(:real, "is not valid")
      return false
    else
      self.save
    end
  end

  def inquiry=(params)
    self.hash_data = self.inquiry.merge(params)
   end

  def inquiry
    options = self.hash_data
    defaults = {
      name:'',
      email:'',
      phone:'',
      remarks:'',
      real:'',
      answer:'real:not',
      reply:''
    }.with_indifferent_access
    # merge with current data in case new attribute add
    self.hash_data = defaults.merge(self.hash_data)
    return self.hash_data
  end
end
