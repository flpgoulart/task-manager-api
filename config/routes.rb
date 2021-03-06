require 'api_version_constraint'

Rails.application.routes.draw do

  devise_for :users, only: [:sessions], controllers: {sessions: 'api/v1/sessions'}

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # namespace é utilizado para agrupar os Controles (controllers), de forma a melhorar o codigo
  # neste primeiro caso, o agrupamento chama-se api e o formato de troca de dados a ser utilizado é o json
  # a constraints neste caso, exige que o subdomínio seja api, ficando dessa forma api.nome-site.com
  # o comando "path: '/'" inibe a necessidade de informar o caminho, ou seja, antes do comando deveria ser
  # api.nome-site.com/api e com este comando ele entende como api.nome-site.com
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    # este caso é um agrupamento dentro do namespace api, para controlar as versões
    # o comando path neste caso, evita que o usuário tenha que informar a versão na URL
    # o controle da versão está pelo cabeçalho http, informando a versão na requisição esse dado
    # o ApiVersionConstraint é uma classe criada, e está localizada na pasta "lib"
    namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1) do
      #irá criar a rota para o users e somente para a action show
      resources :users, only: [:show, :create, :update, :destroy]
      resources :sessions, only: [:create, :destroy]
      resources :tasks, only: [:index, :show, :create, :update, :destroy]
    end

    #por questão de leitura e interpretação das rotas, é sempre importante o bloca da versão default ficar por ultimo no código
    namespace :v2, path: '/', constraints: ApiVersionConstraint.new(version: 2, default: true) do
      mount_devise_token_auth_for 'User', at: 'auth'
      #irá criar a rota para o users e somente para a action show
      resources :users, only: [:show, :create, :update, :destroy]
      resources :sessions, only: [:create, :destroy]
      resources :tasks, only: [:index, :show, :create, :update, :destroy]
      resources :task_types, only: [:index, :show, :create, :update, :destroy]
    end
  end 
end
