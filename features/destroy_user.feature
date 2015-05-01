Feature: Allow an admin to destroy a user
  As an admin
  In order to maintain the quality of the community and exercise godlike powers
  I want to destroy a user

Background:
  Given the following users:
    | email                | password  | role      | name         |
    | admin@admin.com      | superpass | admin     | Diane        |
    | regularman@email.com | normpass  | volunteer | Normal Norman|
    | something@here.com   | password  | volunteer | Bob Jones    |

Scenario: Delete a user as an admin
  Given I am logged in as "admin@admin.com" with password "superpass"
  When I am on the leaderboard page
  Then I should see "Normal Norman"
  When I am on the user profile page for "regularman@email.com"
  Then I should see a delete button with parent "div.panel-heading"
  When I click the delete button
  And I press "Confirm"
  Then I should see "User deleted!"
  And I should not see "Normal Norman"

Scenario: Can't delete user as a volunteer
  Given I am logged in as "regularman@email.com" with password "normpass"
  When I am on the leaderboard page
  Then I should see "Bob Jones"
  When I am on the user profile page for "something@here.com"
  Then I should not see a delete button with parent "div.panel-heading"
