FactoryGirl.define do
  factory :user do
    email 'normal@user.com'
    password 'password'
    role 'volunteer'
  end

  factory :admin, class: User do
    email 'admin@user.com'
    password 'password'
    role 'admin'
  end

  factory :superadmin, class: User do
    email 'superadmin@user.com'
    password 'password'
    role 'superadmin'
  end

  factory :facebook_identity, class: Identity do
    uid 'liara'
    provider 'facebook'
  end

  factory :video, class: Video do
    title 'Factory-Created Video'
    youtube_id 'FavUpD_IjVY'
    description 'Factory-created description.'
  end
end
