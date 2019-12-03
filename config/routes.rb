Rails.application.routes.draw do

  devise_for :users,
             defaults: { format: :json },
             path_names: {
                 sign_in: 'login',
                 sign_out: 'logout',
                 registration: 'signup'
             },
             controllers: {
                 sessions: 'sessions',
                 registrations: 'registrations'
             }
  scope defaults: { format: :json } do
    resources :tweets
    resources :users, only: [] do
      resources :tweets, only: :index
      collection do
        get :profile
        get :tweets
      end
      member do
        post :follow
        delete :unfollow
      end
    end
  end

end
