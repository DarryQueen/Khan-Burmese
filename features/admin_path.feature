Feature: Restrict access to the admin portal.

  As an admin
  So that I can manage the site
  I want to be able to open the admin portal and restrict its access.

Background:
  Given the following users:
    | email                | password  | role        | name         |
    | su@wonderland.com    | superpass | superadmin  | Vivienne     |
    | admin@wonderland.com | normpass  | admin       | Lara Croft   |
    | ice@tea.com          | borepass  | volunteer   | Sona Buvelle |

Scenario: Access the admin portal as an admin.
  Given I am logged in as "su@wonderland.com" with password "superpass"
  Then I should see "Signed in successfully."
  When I go to the admin portal
  Then I should see "Khan Burmese Admin"

Scenario: Access the admin portal as a vanilla user.
  Given I am logged in as "ice@tea.com" with password "borepass"
  Then I should see "Signed in successfully."
  When I go to the admin portal
  Then I should see "This is a sensitive portal"

Scenario: Access the previews page as an admin.
  Given I am logged in as "su@wonderland.com" with password "superpass"
  When I go to the previews page
  Then I should see "Previews"

Scenario: Access the previews page as a vanilla user.
  Given I am logged in as "ice@tea.com" with password "borepass"
  When I go to the previews page
  Then I should see "Insufficient permissions."
