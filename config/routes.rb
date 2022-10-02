Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "api/v1/auth/registrations"
      }

      controller :cheervotes do
        resources :cheervotes, only: [:show]
        # get "/cheervotes" => "cheervotes#show"
      end

      controller :cv_questions do
        resources :cv_questions, only: [:show]
      end

      controller :hc_constituencies do
        resources :hc_constituencies, only: [:index, :show]
      end

      controller :hc_cvs do
        resources :hc_cvs, only: [:create]
      end

      controller :hc_members do
        get "/hc_members/hc_constituencies/:id", to: "hc_members#index_of_hc_constituency"
        get "/hc_members/hc_pr", to: "hc_members#index_of_hc_pr"
      end

      controller :hr_cvs do
        resources :hr_cvs, only: [:create]
      end

      controller :hr_members do
        get "/hr_members/prefectures/:id", to: "hr_members#index_of_prefecture"
        get "/hr_members/hr_pr_blocks/:id", to: "hr_members#index_of_hr_pr_block"
      end

      controller :hr_pr_blocks do
        resources :hr_pr_blocks, only: [:index, :show]
      end

      controller :political_parties do
        get "/political_parties/active", to: "political_parties#index_having_active_members"
        resources :political_parties, only: [:show]
      end

      controller :political_party_members do
        get "/political_party_members/hr_members/:id", to: "political_party_members#index_of_hr_members"
        get "/political_party_members/hc_members/:id", to: "political_party_members#index_of_hc_members"
      end

      controller :politicians do
        resources :politicians, only: [:index, :show]
      end

      controller :prefectures do
        resources :prefectures, only: [:index, :show]
      end

      # controller :users do
      #   resources :users, only: [:index]
      # end

      controller :tests do
        resources :tests, only: [:index]
      end

      namespace :auth do
        resources :sessions, only: [:index]
      end

    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
