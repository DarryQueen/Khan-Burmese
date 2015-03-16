Feature: Allow a user to create an account.

  As a potential volunteer
  So that I can join KA Burmese
  I want to be able to sign up for an account.

Background:
  Given I am on the signup page

Scenario: Sign up with valid email and password.
  When I fill in "user_email" with "test@test.com"
  And I fill in "user_password" with "password"
  And I fill in "user_password_confirmation" with "password"
  And I press "Sign Up"
  Then I should see "A message with a confirmation link has been sent to your email address."

Scenario: Sign up with invalid password.
  When I fill in "user_email" with "test@test.com"
  And I fill in "user_password" with "pass"
  And I fill in "user_password_confirmation" with "pass"
  And I press "Sign Up"
  Then I should see "Password must contain at least"
