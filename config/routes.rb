Rails.application.routes.draw do
  resources :users, only: :index do
    resources :periods, except: :show
  end

  devise_for :users,
             path: '',
             path_names: {
               sign_in: :login,
               sign_out: :logout
             },
             controllers: {
               sessions: :sessions,
             }
end
