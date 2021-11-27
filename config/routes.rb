Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/timeular/tracking_status', to: 'timeular#tracking_status'
  post '/timeular/start_tracking', to: 'timeular#start_tracking'
  post '/timeular/stop_tracking', to: 'timeular#stop_tracking'

  post '/timeular/add_tags', to: 'timeular#add_tags'
  post '/timeular/tags', to: 'timeular#tags'
  post '/timeular/comment', to: 'timeular#comment'
end
