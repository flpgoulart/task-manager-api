FactoryGirl.define do 
    factory :task do
        title { Faker::Lorem.sentence }
        description { Faker::Lorem.paragraph }
        deadline { Faker::Date.forward }
        done false
        
        #como no modelo temos o belongs_to para user, o FactoryGirl cria automaticamente um usuário utilizando a associação
        user
    end 

end 