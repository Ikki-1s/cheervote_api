Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations'
      }

      controller :prefectures do
        resources :prefectures, only: [:index, :show]
      end

      controller :hr_members do
        resources :hr_members
        get '/hr_members/prefectures/:id', to: 'hr_members#index_of_prefecture'
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end