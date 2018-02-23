require 'rails_helper'

# este comando serve para descrever o que o teste
RSpec.describe 'Task API', type: :request do
    before { host! 'api.taskmanager.dev' }
    
    let!(:user) { create(:user) }
    let(:headers) do 
        {
            'Accept' => 'application/vnd.taskmanager.v1',
            'Content-Type' => Mime[:json].to_s,
            'Authorization' => user.auth_token
        }
    end

    describe 'GET /tasks' do
        before do
            # é do FactoryGirl, serve para criar vários cadastros do mesmo objeto
            # neste caso, ele vai criar 5x, de acordo com o que foi parametrizado no factories/tasks
            create_list(:task, 5, user_id: user.id)
            get '/tasks', params: {}, headers: headers 
        end
        
        it 'returns status code 200' do
            expect(response).to have_http_status(200)  
        end

        it 'returns 5 tasks from database' do
            expect(json_body[:tasks].count).to eq(5)
        end
    end
    
    describe 'GET /tasks/:id' do
        let(:task) {create(:task, user_id: user.id)}

        before { get "/tasks/#{task.id}", params: {}, headers: headers }

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end

        it 'returns the json for tasks' do
            expect(json_body[:title]).to eq(task.title)
        end
        
    end
    
    describe 'POST /tasks' do
        before do
            post '/tasks', params: { task: task_params }.to_json, headers: headers
        end
        
        context 'when the params are valid' do
            let(:task_params) { attributes_for(:task) } 

            it 'returns status code 201' do
                expect(response).to have_http_status(201)
            end
            
            it 'save the task in the database' do
                expect( Task.find_by( title: task_params[:title] ) ).not_to be_nil 
            end

            it 'returns the json for created task' do
                expect(json_body[:title]).to eq(task_params[:title])
            end

            it 'assigns the created task to the current user' do
                expect(json_body[:user_id]).to eq(user.id)
            end
        end

        context 'when the params are invalid' do
            let(:task_params) { attributes_for(:task, title: ' ') }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not save the task in the database' do
                expect( Task.find_by( title: task_params[:title] ) ).to be_nil 
            end

            # neste teste, ele especifica que quer especificamente o erro no titulo
            it 'returns the json errors for title' do
                expect(json_body[:errors]).to have_key(:title)
            end
        end
        
        
    end
    
    describe 'PUT /task/:id' do
      let!(:task) { create(:task, user_id: user.id ) }
      before do
          put "/tasks/#{task.id}", params: { task: task_params }.to_json, headers: headers
      end
      
      context 'when the params are valid' do
          let(:task_params) { { title: 'New task title' } }

          it 'return status code 200' do
            expect(response).to have_http_status(200) 
          end

          it 'returns the json for updated tasks' do
            expect(json_body[:title]).to eq(task_params[:title])
          end

          it 'updates the task in the database' do 
            expect(Task.find_by(title: task_params[:title])).not_to be_nil 
          end
      end
    
      context 'when the params are invalid' do
          let(:task_params) { { title: ' ' } }

          it 'return status code 422' do
            expect(response).to have_http_status(422) 
          end

          it 'returns the json error for title' do
            expect(json_body[:errors]).to have_key(:title)
          end

          it 'does not update the task in the database' do
            expect( Task.find_by(title: task_params[:title]) ).to be_nil
          end
      end
      
    end
end