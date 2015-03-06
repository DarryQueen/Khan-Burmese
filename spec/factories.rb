FactoryGirl.define do
  factory :user do
    email 'normal@user.com'
    password 'password'
    admin false
  end

  factory :admin, class: User do
    email 'admin@user.com'
    password 'password'
    admin true
  end

  factory :facebook_identity, class: Identity do
    uid 'liara'
    provider 'facebook'
  end
end
