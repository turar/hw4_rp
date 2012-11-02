Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
      # each returned element will be a hash whose key is the table header.
      # you should arrange to add that movie to the database here.
      Movie.create!(movie)
  end
end

Then /^the director of "(.*)" should be "(.*)"$/ do |arg1, arg2|
  movie = Movie.find_by_title(arg1)
  movie.director.should == arg2
end

Then /^(?:|I )should be on the home page/ do
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == movies_path
  else
    assert_equal movies_path, current_path
  end
end
