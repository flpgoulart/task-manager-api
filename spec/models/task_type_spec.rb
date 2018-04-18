require 'rails_helper'

RSpec.describe TaskType, type: :model do
  let(:task_type) { build(:task_type) }
  
  it { is_expected.to validate_presence_of :name }

  # este passo é importante listar todos os campos previstos na aplicação, caso tenha algum não previsto, ele acusará no teste
  it { is_expected.to respond_to(:name) }
  
end
