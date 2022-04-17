Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "api/v1/auth/registrations"
      }

      controller :hr_members do
        resources :hr_members
        get "/hr_members/prefectures/:id", to: "hr_members#index_of_prefecture"
        get "/hr_members/hr_pr_blocks/:id", to: "hr_members#index_of_hr_pr_block"
      end

      controller :hr_pr_blocks do
        resources :hr_pr_blocks, only: [:index, :show]
      end

      controller :prefectures do
        resources :prefectures, only: [:index, :show]
      end

    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
