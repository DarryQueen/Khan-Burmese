Feature: Allow a user to login.
  
  As a user
  So that I can use the site
  I want to be able to log in manually.

Background:
  Given I am on the home page

Scenario: Log in with faulty email.
  When I fill in "user_email" with "the@cake"
  And I fill in "user_password" with "isalie"
  And I press "Log In"
  Then I should see "Invalid email or password."
