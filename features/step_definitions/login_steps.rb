Given /^I am not authenticated$/ do
  page.driver.submit :delete, destroy_user_session_path, {}
end

Given /^I log in by email$/ do
  email = 'testing@man.net'
  password = 'secretpass'
  User.create(:email => email, :password => password, :password_confirmation => password).confirm!

  visit '/users/sign_in'
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "Log In"
end

Given /^(?:|I )am logged in as "([^"]*)" with password "([^"]*)"$/ do |email, password|
  visit '/users/sign_in'
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "Log In"
end
