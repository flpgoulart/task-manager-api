FactoryGirl.define do 
    factory :task_type do
        name { Faker::Lorem.sentence }
    end 

end 