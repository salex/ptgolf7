class Notice < Stash
  def update_inquiry(params)
    self.hash_data= params[:inquiry].to_h
    is_valid?
  end

end
