Feature: Perform video searching with AJAX.

  As a user
  So that I can find a video to translate
  I want to search the videos list for a specific video by tag or title.

Background:
  Given the following videos:
    | title                          | description        | youtube_id  | subjects | starred |
    | The Help                       | A great movie.     | J_ajv_6pUnI | Math     | true    |
    | Star Trek                      | A good movie.      | sKqDROmF6go | History  | false   |
    | Crouching Tiger, Hidden Dragon | A wonderful movie. | s1hs62Is67s | History  | false   |
  And I am logged in
  And I am on the videos page

@javascript
Scenario: See entire videos listing.
  Then I should see "The Help"
  And I should see "Star Trek"
  And I should see "Crouching Tiger, Hidden Dragon"
  And I should see a star next to "The Help"
  And I should not see a star next to "Star Trek"

@javascript
Scenario: Search for a specific video by title.
  When I fill in "search" with "Crouching Tiger, Hidden Dragon"
  Then I should see "Crouching Tiger, Hidden Dragon"

@javascript
Scenario: Fill in faulty search criteria.
  When I fill in "search" with "blahblahblahnonsense"
  Then I should not see "The Help"
  And I should not see "Star Trek"
  And I should not see "Crouching Tiger, Hidden Dragon"
