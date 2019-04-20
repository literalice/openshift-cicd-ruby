require 'sinatra'

get '/' do
  "Hello sinatra! / ruby #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE}) - #{RUBY_PLATFORM}"
end
