install:
	rm fabricio-*.*.*.gem 2> /dev/null || true
	gem build fabricio.gemspec
	gem install fabricio-*.*.*.gem

lint:
	rubocop -l
