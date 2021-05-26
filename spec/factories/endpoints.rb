FactoryBot.define do
    factory :endpoint do
        verb { Endpoint::METHODS.sample }
        path { Faker::File.dir(root: '/') }
        response_code { Faker::Number.within(range: 100..599) }
    end
end