class Notice < Stash
  def update_inquiry(params)
    self.hash_data= params[:inquiry].to_h
    puts "DDDDDDD got here???"
    is_valid?
  end

end
