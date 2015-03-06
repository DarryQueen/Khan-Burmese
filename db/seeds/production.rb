# Seed single administrator.
user = User.create :email => 'admin@test.com', :password => 'administrator', :password_confirmation => 'administrator'
user.toggle!(:admin)
puts 'New user created: ' << user.email
