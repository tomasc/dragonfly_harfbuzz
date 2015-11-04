require 'dragonfly'

require "dragonfly_harfbuzz/dom_attrs_service"
require "dragonfly_harfbuzz/flatten_svg_service"
require "dragonfly_harfbuzz/markup_svg_service"

require "dragonfly_harfbuzz/plugin"
require "dragonfly_harfbuzz/version"

Dragonfly.app.configure do
  plugin :harfbuzz
end
