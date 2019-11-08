Rails.application.routes.draw do
  resources :users, except: :show do
    resources :periods, except: :show
    resources :monthly_reports, path: 'monthly-reports', only: :create
  end

  devise_for :users,
             path: '',
             path_names: {
               sign_in: :login,
               sign_out: :logout
             },
             controllers: {
               sessions: :sessions
             }
end
