Rails.application.routes.draw do
  get 'auth/auth'
  get 'auth/pocket_redirect', to: 'auth#pocket_redirect'


  root 'auth#auth'
end
