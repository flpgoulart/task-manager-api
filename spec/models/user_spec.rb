require 'rails_helper'

RSpec.describe User, type: :model do

  # o comando build só cria em memória e não grava em banco, recomendado nos testes de model
  let(:user) { build(:user) }

  #it { expect(user).to respond_to(:email) }

  # o context é uma forma de agrupar os testes por contexto, algo em comum
#  context 'when name is blank' do
#    # a instrução será executada antes de cada teste (quando não informa o tipo ele usa o before(:each))
#    # leitura seria, enquanto o nome do usuário for em branco, espero que não seja válido
#    before {  user.name = " "}
#    it { expect(user).not_to be_valid }
#  end


  # o context é uma forma de agrupar os testes por contexto, algo em comum
#  context 'when name is nil' do
    # a instrução será executada antes de cada teste (quando não informa o tipo ele usa o before(:each))
    # leitura seria, enquanto o nome do usuário for em branco, espero que não seja válido
#    before {  user.name = nil}
#    it { expect(user).not_to be_valid }
#  end

  #este metodo é utilizando o shouda_matric, para validar a mesma instrução acima, usando apenas 1 linha
  #it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to allow_value('flpgoulart@gmail.com').for(:email) }

  it { is_expected.to validate_uniqueness_of(:auth_token) }
  #it { is_expected.to validate_numericality_of(:age) }

  #implementa um teste de instancia, neste caso o info é definido como um método dentro do model user
  describe '#info' do
    it 'returns email, created_at and a Token' do 
      user.save!

      #neste caso, ele cria um metodo duble que substitui o original Devise.friendly_token
      allow(Devise).to receive(:friendly_token).and_return('abc123xyzTOKEN')

      expect(user.info).to eq("#{user.email} - #{user.created_at} - Token: abc123xyzTOKEN")
    end
  end
  
  describe '#generate_authentication_token!' do
    it 'generates a unique auth token' do
      allow(Devise).to receive(:friendly_token).and_return('abc123xyzTOKEN')
      user.generate_authentication_token!

      expect(user.auth_token).to eq('abc123xyzTOKEN')
    end

    it 'generates another token when the current auth token alredy has been taken' do 
      allow(Devise).to receive(:friendly_token).and_return('abc123tokenxyz', 'abc123tokenxyz', 'abcXYZ123456789')
      existing_user = create(:user)
      user.generate_authentication_token!

      expect(user.auth_token).not_to eq(existing_user.auth_token)
    end
    
  end
  
  # outras maneiras de se fazer o teste
  #before { @user = FactoryGirl.build(:user) }

  #it { expect(@user).to respond_to(:email) }
  #it { expect(@user).to respond_to(:name) }
  #it { expect(@user).to respond_to(:password) }
  #it { expect(@user).to respond_to(:password_confirmation) }
  #it { expect(@user).to be_valid }

  #it { is_expected.to respond_to(:email) }
  #it { is_expected.to respond_to(:name) }
  
  ########para testar no terminal
  #bundle exec spring rspec
  
end
