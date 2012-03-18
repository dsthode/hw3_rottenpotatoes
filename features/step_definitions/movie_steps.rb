# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    dbMovie = Movie.new(:title => movie[:title], :rating => movie[:rating], :release_date => movie[:release_date])
    dbMovie.save!
  end
  movies_table.hashes.size.should == Movie.count
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  assert false, "Unimplmemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  action = uncheck ? 'uncheck' : 'check'
  rating_list.split(',').each do |rating|
    step %{I #{action} \"ratings_#{rating.strip}\"}
  end
end

Then /I should (not )?see ratings: (.*)/ do |visible,ratings|
  ratings.split(',').each do |rating|
    if page.respond_to? :should
      if visible == nil
        page.should have_xpath("//table[@id='movies']/tbody/tr/td[2][starts-with(., '#{rating.strip}') and '#{rating.strip}' = substring(., string-length(.)- string-length('#{rating.strip}') +1)]")
      else
        page.should_not have_xpath("//table[@id='movies']/tbody/tr/td[2][starts-with(.,'#{rating.strip}') and ends-with(., '#{rating.strip}')]")
      end
    else
      if visible == nil
        assert page.has_xpath("//table[@id='movies']/tbody/tr/td[2][starts-with(.,'#{rating.strip}') and ends-with(., '#{rating.strip}')]")
      else
        assert page.has_no_xpath("//table[@id='movies']/tbody/tr/td[2][starts-with(.,'#{rating.strip}') and ends-with(., '#{rating.strip}')]")
      end
    end
  end
end

Then /I should see no movies/ do
  if page.respond_to? :should
    page.should have_xpath("//table[@id='movies']/tbody[count(./tr) = 0]")
  else
  end
end

Then /I should see all the movies/ do
  if page.respond_to? :should
    page.should have_xpath("//table[@id='movies']/tbody[count(./tr) = #{Movie.count}]")
  else
  end
end
