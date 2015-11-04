$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "bundler/setup"

require "minitest"
require "minitest/autorun"
require "minitest/spec"

require "dragonfly_harfbuzz"

# ---------------------------------------------------------------------

SAMPLES_DIR = Pathname.new(File.expand_path('../../samples', __FILE__))

# ---------------------------------------------------------------------

def test_app name=nil
  app = Dragonfly::App.instance(name)
  app.datastore = Dragonfly::MemoryDataStore.new
  app.secret = "test secret"
  app
end