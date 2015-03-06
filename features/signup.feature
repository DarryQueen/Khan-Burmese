Feature: allow a user to create an account
  
  As a potential volunteer
  So that I can join KA Burmese
  I want to be able to sign up for an account
  
Background:
  Given I am on the signup page
  
Scenario: sign up on the signup page
  When I fill in "user_email" with "test@test.com"
  And I fill in "user_password" with "password"
  And I fill in "user_password_confirmation" with "password"
  And I press "Sign Up"
  Then I should see "Welcome! You have signed up successfully."