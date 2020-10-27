Rails.application.routes.draw do
  get '/' => 'welcome#index'
  get 'feed/read' => 'feed#read'
  get 'feed/skip_article' => 'feed#skip_article', :as => :skip_article
  get 'feed/archive' => 'feed#archive', :as => :archive
  get 'pocket/auth' => 'pocket#auth', :as => :pocket_authorize
  get 'pocket/pocket_redirect' => 'pocket#pocket_redirect'
  get 'pocket/load_feed' => 'pocket#load_feed'

  root 'welcome#index'
end
