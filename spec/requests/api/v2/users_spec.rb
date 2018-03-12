require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'Users API', type: :request do
  # o let com a exclamação força a ser executado o comando, neste caso para instanciar o user
  # o create cria o objeto no banco de dados, diferente do build que só instancia em memória
  let!(:user) { create(:user) }
  let!(:auth_data) { user.create_new_auth_token }
  #esta definição é para não repetirmos alguns trechos de código
  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v2',
      'Content-Type' => Mime[:json].to_s,
      'access-token' => auth_data['access-token'],
      'uid' => auth_data['uid'],
      'client' => auth_data['client']
    }
  end

  before { host! 'api.taskmanager.dev' }

  #para recuperar um dado -show
  describe 'GET /auth/validate_token' do

    # este contexto serve para agrupar quando o usuário existir
      context 'when the request headers are valid' do

        before do
          get '/auth/validate_token', params: {}, headers: headers
        end
        
        it 'returns the user id' do
          # Espero que o ID contido no Body seja igual ao user_id definido no inicio do comando
          expect(json_body[:data][:id].to_i).to eq(user.id)
        end
        
        #compara se deu tudo certo na requisição, esperado para o código 200
        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end 
      end 

      context 'when the request headers are not valid' do
        before do
          headers['access-token'] = "invalid_token"
          get '/auth/validate_token', params: {}, headers: headers
        end
        
        it 'returns status code 401' do
          expect(response).to have_http_status(401)
        end
      end 
  end 
  
  #para enviar um novo dado -create
  describe 'POST /auth' do
    before do
      post '/auth', params: user_params.to_json, headers: headers
    end 

    context 'when the request params are valid' do
      #attributes_for pertence a biblioteca do FactoryGirl
      let(:user_params) { attributes_for(:user) }  

      it 'returns status code 200' do 
        expect(response).to have_http_status(200)
      end

      it 'returns json data for the created user' do
        expect(json_body[:data][:email]).to eq(user_params[:email]) 
      end
      
    end
    
    context 'when the request params are invalid' do
      let(:user_params) { attributes_for(:user, email: 'invalid_email@') }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end 

      it 'returns the json data for the errors' do
        expect(json_body).to have_key(:errors) 
      end
    end
  end

  #para atualizar um dado -update
  describe 'PUT /auth' do

    before do
      put '/auth', params: user_params.to_json, headers: headers
    end 

    context 'when the request params are valid' do
      let(:user_params) { { email: 'new_email@task-manager.com' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200) 
      end

      it 'returns the json data for the update user' do
        expect(json_body[:data][:email]).to eq(user_params[:email])
      end 
    end

    context 'when the request params are invalid' do
      let(:user_params) { { email: 'invalid_email@' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422) 
      end

      it 'returns the json data for the errors' do
        expect(json_body).to have_key(:errors) 
      end
    end
    
  end
  
  #para excluir um dado -destroy
  describe 'DELETE /auth' do
    before do
      delete '/auth', params: {}, headers: headers
    end
    
    it 'returns status code 200' do
      expect(response).to have_http_status(200) 
    end

    it 'removes the user from database' do 
      expect(User.find_by(id: user.id)).to be_nil
    end
    
  end
  
end
