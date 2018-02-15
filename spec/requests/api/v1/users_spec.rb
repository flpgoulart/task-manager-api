require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'Users API', type: :request do
  # o let com a exclamação força a ser executado o comando, neste caso para instanciar o user
  # o create cria o objeto no banco de dados, diferente do build que só instancia em memória
  let!(:user) { create(:user) }
  let(:user_id) { user.id }

  before { host! "api.taskmanager.dev" }

  describe "GET /users/:id" do
    before do
      headers = { "Accept" => "application/vnd.taskmanager.v1" }
      get "/users/#{user_id}", params: {}, headers: headers
    end

      # este contexto serve para agrupar quando o usuário existir
      context "when the user exists" do
        it "returns the user" do
          #nesta instrução, eu pego o resultado da minha requisição GET e converto para JSON o Body da mensagem
          user_response = JSON.parse(response.body)
          # Espero que o ID contido no Body seja igual ao user_id definido no inicio do comando
          expect(user_response["id"]).to eq(user_id)
        end
        
        #compara se deu tudo certo na requisição, esperado para o código 200
        it "returns status code 200" do
          expect(response).to have_http_status(200)
        end 
      end 

      context "when the user does not exists" do
        let(:user_id) { 10000 }
        it "returns status code 404" do
          expect(response).to have_http_status(404)
        end
      end 
  end 
end
