Feature: Import videos from a CSV file.

  As an administrator
  So that I migrate the previous system
  I want to import old videos from a CSV spreadsheet.

Background:
  Given the following videos:
    | title                       | description         | youtube_id  | duration |
    | Meryl Streep's Best of Best | A really great gig. | m5kjb8xtdho | 300      |

Scenario: Should not display to normal users.
  Given I am logged in
  And I am on the videos import page
  Then I should see "Insufficient permissions."

Scenario: Import incorrectly.
  Given I am logged in as admin
  And I am on the videos import page
  Then I should see "Download Template"
  When I press "Import"
  Then I should see "Missing file."
  When I upload the file "non_srt.txt" to "file"
  And I press "Import"
  Then I should see "Invalid file type."

@javascript
Scenario: Import a CSV file properly.
  Given I am logged in as admin
  And I am on the videos import page
  When I upload the file "doc.csv" to "file"
  And I press "Import"
  Then I should be on the videos page
  And I should see "Video(s) imported!"
  And I should see "Charlie bit my finger - again !"
  And I should see "Meryl Streep's Best of Best"
  And I should not see "Top Meryl Streep Performances"
