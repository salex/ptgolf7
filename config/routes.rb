Rails.application.routes.draw do
  resources :posts do
    collection do
      get :instructions
      get :test
    end
    member do
      get :print
    end
    resources :comments
  end
  
  namespace :games do
    resources :pending, only: [:show, :update] do
      member do
        get :add_players
        get :adjust_teams
        get :reform_teams
        get :assign_teams
        get :swap_teams
        get :score_teams
        get :score_cardp
        get :score_card
        get :indv_score_card
        get :print_teams
        get :blind_draw
        patch :update_assigned_teams
        patch :update_swapped_teams
        patch :update_scores
      end
    end
  end

  namespace :games do
    resources :scheduled, only: [:show,:update] do
      member do
        get :form_teams
        get :assign_teams
        patch :update_pays
        patch :update_teams
        patch :update_assigned_teams
      end
    end
  end

  namespace :games do
    resources :scored, only: [:show] do
      member do
        get :rescore_teams
        get :score_par3s
        get :score_skins
        patch :update_skins
        patch :update_par3s
      end
    end
  end

  resources :games do
    collection do
      get :new_today
    end

  end

  resources :players do
    member do
      get :recompute_quota
    end
    collection do
      patch :search
      get :player_search
      post :pairings_search
      # get :quota_correction
      # get :add_correction
    end

  end

  resources :clubs do
    collection do
      get :groups
      get :player_search
      get :player
      # get :fix_settings

    end
  end

  resources :groups do
    member do 
      get :add_player
      get :leave
      get :members_search
      get :move_player
      get :print_quotas
      patch :recompute_quotas
      get :stats
      patch :trim_rounds
      get :visit
      patch :stats_refresh
      post :signin
      post :discussin
      patch :duplicate_other_player
      # one time fix
      get :fix_sidegames
      get :expired_players
      patch :trim_expired

    end
  end

  resources :rounds, only: [:show, :edit, :update, :destroy]

  resources :inquiries
  resources :notices do
    member do
      get :display
    end
  end

  resources :users do
    collection do
      post :signin
    end
    member do
      patch :update_profile
      get :profile
    end
  end


  resource :about, only: :show do
    collection do
      get :forming
      get :scoring
      get :teams
      get :eprocess
      get :gmanage
      get :preferences
      get :origin
      get :structure
      get :terminology
      get :club
      get :group
      get :player
      get :round
      get :game
      get :user
      get :changes
      get :limiting
      get :help
      get :features
      get :notices
      get :slim
    end
  end

 # get 'home/show'
 # get 'home/search'
 # get 'home/display'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'login', to: 'groups#login', as: 'login'
  get 'discuss', to: 'groups#discuss', as: 'discuss'

  get 'logout', to: 'users#logout', as: 'logout'
  # get 'develop', to: 'users#develop', as: 'develop'
  get 'profile', to: 'users#profile'
  get 'score_sheet', to: 'home#score_sheet'
  get 'new_score_sheet', to: 'home#places_sheet'

  get 'places_sheet', to: 'home#places_sheet'
  get 'payouts', to: 'home#payouts'
  patch 'payouts/update', to: 'home#update'
  get 'payouts/about', to: 'home#about'
  get 'payouts/about/deals', to: 'home#deals'
  get 'payouts/about/pga', to: 'home#pga'
  get 'payouts/about/rate', to: 'home#rate'





  get 'test', to: 'home#test'
  get 'home', to: 'home#show'
  # get 'autocomplete' , to: 'home#autocomplete'
  # get 'sinners', to: 'home#sinners'
  # get 'saints', to: 'home#saints'
  # get 'gaggle', to: 'home#gaggle'

  # get 'plain', to: 'home#plain'
  get 'changes', to: 'home#changes'
  get 'help', to: 'abouts#help'
  root 'home#index'
  get '*path', to: 'home#redirect'



end
