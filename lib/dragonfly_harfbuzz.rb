require 'dragonfly'
require "dragonfly_harfbuzz/plugin"
require "dragonfly_harfbuzz/version"

module DragonflyHarfbuzz
end

Dragonfly.app.configure do
  plugin :harfbuzz
end