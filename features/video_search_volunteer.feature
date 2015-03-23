Feature: Perform video searching with AJAX.

  As a user
  So that I can find a video to translate
  I want to search the videos list for a specific video by tag or title.

Background:
  Given the following videos:
    | title                          | description        | youtube_id  | tags                                               | starred |
    | The Help                       | A great movie.     | J_ajv_6pUnI | emma, stone, viola, davis, jessica, chastain       | true    |
    | Star Trek                      | A good movie.      | sKqDROmF6go | chris, pine, zoe, saldana, zachary, quinto, action | false   |
    | Crouching Tiger, Hidden Dragon | A wonderful movie. | s1hs62Is67s | zhang, ziyi, michelle, yeoh, chow, yunfat, action  | false   |
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
Scenario: See suggested tags.
  When I fill in "search" with "Jess"
  Then I should see "jessica"

@javascript
Scenario: Search for a specific video by title.
  When I fill in "search" with "Crouching Tiger, Hidden Dragon"
  Then I should see "Crouching Tiger, Hidden Dragon"

@javascript
Scenario: Search for videos by tag.
  When I fill in "search" with "action "
  Then I should see "Star Trek"
  And I should see "Crouching Tiger, Hidden Dragon"

@javascript
Scenario: Fill in faulty search criteria.
  When I fill in "search" with "blahblahblahnonsense"
  Then I should not see "The Help"
  And I should not see "Star Trek"
  And I should not see "Crouching Tiger, Hidden Dragon"
