source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "git@github.com:#{repo_name}.git"
end

# Specify your gem's dependencies in dragonfly_harfbuzz.gemspec
gemspec

gem 'dragonfly', github: 'brendon/dragonfly', branch: 'new_quote_bug'
