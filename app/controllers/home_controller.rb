class HomeController < ApplicationController
  def index
    if Current.group.present?
      if Current.user.present? && Current.user.reset_token && Current.user.reset_token.to_b
        @user = Current.user
        @user.reset_token = ""
        flash.now[:message] = "You Must change your password"
        render template: 'users/profile'
      else
        @notice = Notice.where(Notice.arel_table[:date_data].gt(Date.today)).first
        render template: 'home/group'
      end
    else
      @clubs = Club.order(:name) 
    end
  end

  def score_sheet
    pdf =  Pdf::ScoreSheet.new
    send_data pdf.render, filename: "score_sheet",
      type: "application/pdf",
      disposition: "inline"
  end


  def redirect
    club = Club.find_by(Club.arel_table[:short_name].matches(params[:path]))
    if club.present?
      group = club.groups.find_by(Group.arel_table[:name].matches(params[:format]))
      if group.present?
        reset_session
        session[:group_id] = group.id
        cookies[:group_id] = {value: group.id, expires: Time.now + 3.months}
        params[:format] = 'html'
        # if cookies["last_group_#{group.id}_user"].present?
        #   user = User.find_by(id:cookies["last_group_#{group.id}_user"])
        #   if user.present?
        #     session[:user_id] = user.id
        #     session[:group_id] = user.group_id
        #     session[:name] = user.player.present? ? user.player.name : user.email
        #     session[:expires_at] = Time.now.midnight + 1.day
        #   end
        # end
        redirect_to root_path
      else
        cant_do_that
      end
    else
    # redirect_to '/404'
    cant_do_that(params[:path])
    end
  end
  def autocomplete
    puts "GOT autocomple"
    @search_results = %w(steve jan butch lori james cammie momma peaks grouchie leftey rightey tiiger)
    render layout: false
  end

 def show
  end

  def display
    set_db
  end

  def search
    set_db
    @search_results = []
    @db.each do |k,n|
      if n[:name].downcase.index(params[:input].downcase)
        @search_results << [n[:name],k]
      end
    end
    return(render layout: false)
  end

 private

  def set_db
    names = %w(steve jan butch lori james Jamie Chappel drew sarrah poochie wimpie callie cammie momma peaks grouchie leftey rightey tigger).sort
    @db = {}
    names.each.with_index do |n,i|
      @db[i] = {name:n,id:i}
    end
  end


end
