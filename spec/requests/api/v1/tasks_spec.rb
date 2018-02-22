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
    
end