Rails.application.routes.draw do
  get 'feed/read'
  get 'pocket/auth'
  get 'pocket/pocket_redirect', to: 'pocket#pocket_redirect'
  get 'pocket/load_feed', to: 'pocket#load_feed'


  root 'pocket#auth'
end
