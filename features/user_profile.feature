Feature: Allow a user to see his profile.

  As a volunteer
  So that I network and track statuses of my peers
  I want to be able to view profiles of users.

Background:
  Given the following users:
    | email                | password  | role      | name         |
    | admin@wonderland.com | superpass | admin     | Vivienne     |
    | su@wonderland.com    | normpass  | volunteer | Lara Croft   |
    | ice@tea.com          | borepass  | volunteer | Sona Buvelle |

Scenario: View and edit my own profile.
  Given I am logged in as "su@wonderland.com" with password "normpass"
  And I am on the user profile page for "su@wonderland.com"
  Then I should see "Lara Croft"
  And I should see an edit button with parent "li.list-group-item"

Scenario: View someone else's profile.
  Given I am logged in as "su@wonderland.com" with password "normpass"
  And I am on the user profile page for "ice@tea.com"
  Then I should see "Sona Buvelle"
  And I should not see an edit button with parent "li.list-group-item"

Scenario: Edit all profiles as admin.
  Given I am logged in as "admin@wonderland.com" with password "superpass"
  And I am on the user profile page for "admin@wonderland.com"
  Then I should see "Vivienne"
  And I should see an edit button with parent "li.list-group-item"
  When I go to the user profile page for "ice@tea.com"
  Then I should see "Sona Buvelle"
  And I should see an edit button with parent "li.list-group-item"
