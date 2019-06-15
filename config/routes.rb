Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "accounts#index"

  devise_for :users

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  get 'accounts/:id/items.csv', to: 'accounts#items_to_csv', as: 'items_to_csv'

  resources :accounts , shallow: true do
      get :multi_exhibit, on: :member
      get :schedule, on: :member
      post :get_comment, on: :member, to: "comments#get_multi_comment"
      get :item_exhibited, to: "items#item_exhibited"
      get :item_not_exhibit, to: "items#item_not_exhibit"
      # get :re_exhibit, to: "items#re_exhibit"
      get :re_exhibit, to: "items#re_exhibit"
      post :re_exhibit, to: "items#exec_re_exhibit",as: 'exec_re_exhibit'

         resources :items, shallow: true do
             get :exhibit, on: :member
             post :get_comment, on: :member, to: "comments#get_comment"
             delete :destroy_multi, on: :collection, to: 'items#destroy_multi'
             resources :comments, shallow: true
             end
         end
end
