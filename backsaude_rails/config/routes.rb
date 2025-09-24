# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    resources :enfermeiros, only: [ :create, :update ] do
      collection do
        post :validar_cpf
        post :validar_email
        post :validar_coren
      end
    end
    post "validar_coren", to: "coren_validator#validar"
    post "login", to: "sessoes#create"
    post "validar_senha", to: "sessoes#validar_senha"


    resources :pacientes_fake, param: :codigo_sus, only: [ :show ]
    resources :classificacoes_risco, only: [ :index ]
    resources :pacientes_triagem, only: [ :index, :create, :update, :destroy ]
    resources :recuperar_senhas, only: [ :create ] do
      collection do
        put :update # cria /api/recuperar_senhas/update
      end
    end
  resources :medicos do
    collection do
      get :disponiveis
    end
  end

    resources :relatorios_triagem, only: [ :index, :create, :show ] do
      member do
        get :download
      end
      collection do
        get :estatisticas
      end
    end
  end
end
