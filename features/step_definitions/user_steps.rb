Given /^the following users:$/ do |users|
  users.hashes.each do |user|
    email = user['email']
    password = user['password']
    role = user['role']

    User.create(:email => email, :password => password, :password_confirmation => password, :role => role).confirm!
  end
end
