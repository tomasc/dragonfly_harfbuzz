$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'bundler/setup'

require 'minitest'
require 'minitest/autorun'
require 'minitest/spec'

require 'dragonfly_harfbuzz'

SAMPLES_DIR = Pathname.new(File.expand_path('../samples', __dir__))

def test_app(name = nil)
  Dragonfly::App.instance(name).tap do |app|
    app.datastore = Dragonfly::MemoryDataStore.new
    app.secret = 'test secret'
  end
end
