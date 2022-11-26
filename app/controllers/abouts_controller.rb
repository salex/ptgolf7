class AboutsController < ApplicationController
  # collection do
  #   get :forming
  #   get :scoring
  #   get :teams
  #   get :players
  #   get :preferences
  #   get :origin
  #   get :structure
  #   get :terminology
  #   get :club
  #   get :group
  #   get :player
  #   get :round
  #   get :event
  #   get :user
  # end

  def show
    respond_to do |format|
      format.html { render 'abouts/show' }
      format.json { render :show}
    end
  end

  def origin
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'origin')
  end

  def changes
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'changes')
  end


  def structure
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'structure')
  end


  def forming
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'forming')
  end

  def terminology
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'terminology')
  end

  def scoring
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'scoring')
  end

  def teams
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'teams')
  end

  def eprocess
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'process')
  end

  def preferences
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'preferences')
  end

  def user
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'user')
  end
  
  def game
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'game')
  end

  def round
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'round')
  end

  def player
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'player')
  end

  def group
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'group')
  end

  def club
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'club')
  end

  def limiting
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'limiting')
  end

  def features
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'features')
  end
  def gmanage
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'gmanage')
  end
  def notices
    n = Notice.all.order(:date).reverse
    html = '<div class="mb-2"><strong>Recent Notices</strong></div>'
    n.each do |i|
      html << "<strong>#{i.date}</strong>"
      html << helpers.slim_text(i.slim)
      html << "<br/><br/>"
    end
    render turbo_stream: turbo_stream.replace(
      'content',partial: 'slim', locals:{html:html})
  end

  def slim
    n = Notice.all.order(:date).reverse
    html = ""
    n.each do |i|
      html << "<strong>#{i.date}</strong>"
      html << helpers.slim_text(i.slim)
      html << "<br/><br/>"
    end
    render turbo_stream: turbo_stream.replace(
      'content',partial: 'slim', locals:{html:html})

  end



end
