module UsersHelper
  def role_checkboxes(roles)
    checkboxes = []
    if current_user.is_super?
      role_array = ["super","member","manager","coordinator","scorer","uploader","scheduler"]
    elsif current_user.is_coordinator?
      role_array = ["member",'manager',"coordinator","scorer","uploader","scheduler"]
    else
      role_array = ["member","scorer","uploader","scheduler"]

    end

    role_array.each do |i|
      checkboxes << [i,roles.include?(i)]
    end
    checkboxes
  end
end
