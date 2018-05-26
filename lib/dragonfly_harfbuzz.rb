require 'dragonfly'

require 'dragonfly_harfbuzz/dom_attrs_service'
require 'dragonfly_harfbuzz/flatten_svg_service'
require 'dragonfly_harfbuzz/markup_svg_service'

require 'dragonfly_harfbuzz/plugin'
require 'dragonfly_harfbuzz/version'

module DragonflyHarfbuzz
  class UnsupportedFormat < RuntimeError; end
  class UnsupportedOutputFormat < RuntimeError; end

  SUPPORTED_FORMATS = %w[otf].freeze
  SUPPORTED_OUTPUT_FORMATS = %w[ansi png svg pdf ps eps].freeze
end
