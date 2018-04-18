require 'rails_helper'

RSpec.describe Task, type: :model do

  let(:task) { build(:task) }
  context 'When is new' do
    # quando for novo, o campo "done" não pode estar checado, essa instrução permite isso
    it { expect(task).not_to be_done }
  end

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:task_type) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :task_type_id }
  
  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:deadline) }
  it { is_expected.to respond_to(:done) }
  it { is_expected.to respond_to(:user_id) }
  it { is_expected.to respond_to(:task_type_id) }
  
end
