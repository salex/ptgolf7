module SessionsHelper
  def deny_access(msg = nil)
    msg ||= "Please sign in to access this page."
    flash[:notice] ||= msg
    respond_to do |format|
      format.html {
        redirect_to login_url
      }
      format.js {
        render 'groups/login', :layout=>false
      }
    end
  end

  def sign_out
    group = Current.group
    reset_session
    session[:group_id] = group.id
    cookies.delete("last_group_#{group.id}_user")
  end
  
  def inspect_session
    inspect = {}
    session.keys.each do |k|
      inspect[k] = session[k]
    end
    inspect
  end
end
