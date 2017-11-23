Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :centralised_log do
 	get :prompt_to_upload_log, :on => :collection
 	post :upload_logs, :on => :collection
 	get :querying_logs, :on => :collection
  end
end
