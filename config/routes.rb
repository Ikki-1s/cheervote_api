Rails.application.routes.draw do
  namespace :api do
    controller :health_checks do
      resources :health_checks, only: [:index]
    end

    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "api/v1/auth/registrations"
      }

      namespace :auth do
        resources :sessions, only: [:index]

        devise_scope :api_v1_user do
            post "/guests/sign_in", to: "guests#sign_in"
        end
      end

      controller :cheervotes do
        get "/cheervotes/results/pie", to: "cheervotes#result_for_pie_chart"
        get "/cheervotes/terms/active/:politician", to: "cheervotes#active_cv_terms_of_politician"
        resources :cheervotes, only: [:show]
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
        get "/prefectures/all_constituencies_and_blocks", to: "prefectures#index_with_all_constituencies_and_blocks"
        resources :prefectures, only: [:index, :show]
      end

      controller :signed_in_homes do
        resources :signed_in_homes, only: [:index]
      end

      controller :users do
        # resources :users, only: [:index]
      end

      controller :tests do
        resources :tests, only: [:index]
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
