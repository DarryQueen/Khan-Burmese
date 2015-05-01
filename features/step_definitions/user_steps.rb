Given /^the following users:$/ do |users|
  users.hashes.each do |user|
    User.create(user).confirm!
  end
end

Then /^(?:|I )should( not)? see an? (delete|edit) button with parent "([^"]*)"$/ do |negate, button_type, parent|
  case button_type
    when "delete"
      button_class = ".fa.fa-trash"
    when "edit"
      button_class = ".fa.fa-pencil"
  end 

  css = "#{parent} #{button_class}"
  if negate
    page.should_not have_css(css)
  else
    page.should have_css(css)
  end
end

When /^(?:|I )click the delete button$/ do
  find('i.fa.fa-trash').click
end
