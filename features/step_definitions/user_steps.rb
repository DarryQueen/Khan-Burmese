Given /^the following users:$/ do |users|
  users.hashes.each do |user|
    User.create(user).confirm!
  end
end

Then /^(?:|I )should( not)? see an edit button with parent "([^"]*)"$/ do |negate, parent|
  pencil_class = '.fa.fa-pencil'
  css = "#{parent} #{pencil_class}"

  if negate
    page.should_not have_css(css)
  else
    page.should have_css(css)
  end
end
