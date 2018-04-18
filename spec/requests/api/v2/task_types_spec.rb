require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'Task Type API', type: :request do
    before { host! 'api.taskmanager.dev' }
    
    let!(:user) { create(:user) }
    let!(:auth_data) { user.create_new_auth_token }
    let(:headers) do 
        {
            'Accept' => 'application/vnd.taskmanager.v2',
            'Content-Type' => Mime[:json].to_s,
            'Authorization' => user.auth_token,
            'access-token' => auth_data['access-token'],
            'uid' => auth_data['uid'],
            'client' => auth_data['client']
        }
    end

    describe 'GET /task_types' do

        context 'when no filter param is sent' do
        
            before do
                # é do FactoryGirl, serve para criar vários cadastros do mesmo objeto
                # neste caso, ele vai criar 5x, de acordo com o que foi parametrizado no factories/tasks
                create_list(:task_type, 5)
                get '/task_types', params: {}, headers: headers 
            end
            
            it 'returns status code 200' do
                expect(response).to have_http_status(200)  
            end

            it 'returns 5 task types from database' do
                expect(json_body[:data].count).to eq(5)
            end
        
        end 

        context 'when filter and sorting params is sent' do
            let!(:notebook_task_1) { create(:task_type, name: 'Check if the notebook is broken' ) }
            let!(:notebook_task_2) { create(:task_type, name: 'Buy a new notebook' ) }
            let!(:other_task_1)    { create(:task_type, name: 'Fix the door' ) }
            let!(:other_task_2)    { create(:task_type, name: 'Buy a new car' ) }

            before do
                get '/task_types?q[name_cont]=note&q[s]=name+ASC', params: {}, headers: headers
            end
            
            it 'returns only the task types matching and in the correct order' do
                returned_task_titles = json_body[:data].map { |t| t[:attributes][:name] } #map serve para navegar entre os itens do array

                expect(returned_task_titles).to eq([notebook_task_2.name, notebook_task_1.name])  
            end
            

        end
        

    end
    
    describe 'GET /task_types/:id' do
        let(:task_type) {create(:task_type)}

        before { get "/task_types/#{task_type.id}", params: {}, headers: headers }

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end

        it 'returns the json for task types' do
            expect(json_body[:data][:attributes][:name]).to eq(task_type.name)
        end
        
    end
    
    describe 'POST /task_types' do
        before do
            post '/task_types', params: { task_type: task_type_params }.to_json, headers: headers
        end
        
        context 'when the params are valid' do
            let(:task_type_params) { attributes_for(:task_type) } 

            it 'returns status code 201' do
                expect(response).to have_http_status(201)
            end
            
            it 'save the task type in the database' do
                expect( TaskType.find_by( name: task_type_params[:name] ) ).not_to be_nil 
            end

            it 'returns the json for created task type' do
                expect(json_body[:data][:attributes][:name]).to eq(task_type_params[:name])
            end

        end

        context 'when the params are invalid' do
            let(:task_type_params) { attributes_for(:task_type, name: ' ') }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not save the task type in the database' do
                expect( TaskType.find_by( name: task_type_params[:name] ) ).to be_nil 
            end

            # neste teste, ele especifica que quer especificamente o erro no titulo
            it 'returns the json errors for name' do
                expect(json_body[:errors]).to have_key(:name)
            end
        end
        
        
    end
    
    describe 'PUT /task_types/:id' do
      let!(:task_type) { create(:task_type ) }
      before do
          put "/task_types/#{task_type.id}", params: { task_type: task_type_params }.to_json, headers: headers
      end
      
      context 'when the params are valid' do
          let(:task_type_params) { { name: 'New task title' } }

          it 'return status code 200' do
            expect(response).to have_http_status(200) 
          end

          it 'returns the json for updated task types' do
            expect(json_body[:data][:attributes][:name]).to eq(task_type_params[:name])
          end

          it 'updates the task type in the database' do 
            expect(TaskType.find_by(name: task_type_params[:name])).not_to be_nil 
          end
      end
    
      context 'when the params are invalid' do
          let(:task_type_params) { { name: ' ' } }

          it 'return status code 422' do
            expect(response).to have_http_status(422) 
          end

          it 'returns the json error for name' do
            expect(json_body[:errors]).to have_key(:name)
          end

          it 'does not update the task type in the database' do
            expect( TaskType.find_by(name: task_type_params[:name]) ).to be_nil
          end
      end
      
    end

    describe 'DELETE /task_types/:id' do
      let!(:task_type) { create(:task_type) }

      before do
          delete "/task_types/#{task_type.id}", params: {}, headers: headers
      end
      
      it 'returns status code 204' do
          expect(response).to have_http_status(204)
      end

      it 'removes the task type from the database' do
          expect{ TaskType.find(task_type.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
end