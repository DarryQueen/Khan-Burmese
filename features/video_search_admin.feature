Feature: Perform video searching with AJAX.

  As a user
  So that I can find a video to translate
  I want to search the videos list for a specific video by tag or title.

Background:
  Given the following videos:
    | title                          | description        | youtube_id  | starred |
    | The Help                       | A great movie.     | J_ajv_6pUnI | true    |
    | Star Trek                      | A good movie.      | sKqDROmF6go | false   |
    | Crouching Tiger, Hidden Dragon | A wonderful movie. | s1hs62Is67s | false   |
  And I am logged in as admin
  And I am on the videos page

@javascript
Scenario: See entire videos listing.
  Then I should see "The Help"
  And I should see "Star Trek"
  And I should see "Crouching Tiger, Hidden Dragon"
  And I should see a bright star next to "The Help"
  And I should see a dim star next to "Star Trek"

@javascript
Scenario: Toggle video stars.
  When I click the star next to "The Help"
  Then I should see a dim star next to "The Help"
  When I click the star next to "Star Trek"
  Then I should see a bright star next to "Star Trek"
  When I click the star next to "The Help"
  Then I should see a bright star next to "The Help"
