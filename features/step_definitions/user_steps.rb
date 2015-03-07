Given /^the following users:$/ do |users|
  users.hashes.each do |user|
    email = user['email']
    password = user['password']
    admin = user['admin']

    user = User.new(:email => email, :password => password, :password_confirmation => password)
    user.update_attribute :admin, admin
    user.save!
  end
end