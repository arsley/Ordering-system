FactoryBot.define do
  factory :employee do
    fullname { Faker::Name.name }
    username { Faker::Internet.username }
    password { 'password' }
    password_confirmation { 'password' }

    factory :administor do
      fullname { 'Administor' }
      username { 'admin' }
      password { 'administrator' }
      password_confirmation { 'administrator' }
    end
  end
end
