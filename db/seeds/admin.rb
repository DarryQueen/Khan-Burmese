# Seed single administrator.
user = User.create :name => 'Administrator' :email => 'admin@test.com', :password => 'administrator', :password_confirmation => 'administrator', :role => 'superadmin'
puts "New user created: #{user.email}\n"
