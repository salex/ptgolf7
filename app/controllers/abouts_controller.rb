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
    @template = 'origin'
    render action: :show
  end

  def changes
    @template = 'changes'
    render action: :show
  end


  def structure
    @template = 'structure'
    render action: :show
  end


  def forming
    @template = 'forming'
    render action: :show
  end

  def terminology
    @template = 'terminology'
    render action: :show
  end

  def scoring
    @template = 'scoring'
    render action: :show
  end

  def teams
    @template = 'teams'
    render action: :show
  end

  def eprocess
    @template = 'process'
    render action: :show
  end

  def preferences
    @template = 'preferences'
    render action: :show
  end

  def user
    @template = 'user'
    render action: :show
  end
  def event
    @template = 'event'
    render action: :show
  end
  def round
    @template = 'round'
    render action: :show
  end
  def player
    @template = 'player'
    render action: :show
  end
  def group
    @template = 'group'
    render action: :show
  end
  def club
    @template = 'club'
    render action: :show
  end
  def limiting
    @template = 'limiting'
    render action: :show
  end
  def features
    @template = 'features'
    render action: :show
  end



end
