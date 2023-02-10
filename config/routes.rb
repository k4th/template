# frozen_string_literal: true

Rails.application.routes.draw do
  put :update_locale, to: 'beyond_canvas/system#update_locale'

  get :callback, to: 'beyond_canvas/authentications#callback'

  resources :shops, only: [] do
    member do
      post :beyond_webhooks, to: 'beyond_canvas/webhooks#receive'
    end
  end
end
