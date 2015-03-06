Feature: Restrict access to the admin portal.

  As an admin
  So that I can manage the site
  I want to be able to open the admin portal and restrict its access.

Background:
  Given the following users:
    | email                | password  | admin |
    | admin@wonderland.com | superpass | true  |
    | ice@tea.com          | borepass  | false |

Scenario: Access the admin portal as an admin.
  Given I am logged in as "admin@wonderland.com" with password "superpass"
  Then I should see "Signed in successfully."
  When I go to the admin portal
  Then I should see "Khan Burmese Admin"

Scenario: Access the admin portal as a vanilla user.
  Given I am logged in as "ice@tea.com" with password "borepass"
  Then I should see "Signed in successfully."
  When I go to the admin portal
  Then I should not see "Khan Burmese Admin"
