require 'api_version_constraint'

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # namespace é utilizado para agrupar os Controles (controllers), de forma a melhorar o codigo
  # neste primeiro caso, o agrupamento chama-se api e o formato de troca de dados a ser utilizado é o json
  # a constraints neste caso, exige que o subdomínio seja api, ficando dessa forma api.nome-site.com
  # o comando "path: '/'" inibe a necessidade de informar o caminho, ou seja, antes do comando deveria ser
  # api.nome-site.com/api e com este comando ele entende como api.nome-site.com
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: "/" do
    # este caso é um agrupamento dentro do namespace api, para controlar as versões
    # o comando path neste caso, evita que o usuário tenha que informar a versão na URL
    # o controle da versão está pelo cabeçalho http, informando a versão na requisição esse dado
    # o ApiVersionConstraint é uma classe criada, e está localizada na pasta "lib"
    namespace :v1, path: "/", constraints: ApiVersionConstraint.new(version: 1, default: true) do

    end
  end 
end
