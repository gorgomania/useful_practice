FactoryBot.define do
    factory :task do
      name { FFaker::Name.name }
      project
    end
end
