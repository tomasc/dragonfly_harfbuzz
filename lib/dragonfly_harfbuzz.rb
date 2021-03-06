require 'dragonfly'
require 'active_support/core_ext/object/blank'

require 'dragonfly_harfbuzz/dom_attrs_service'
require 'dragonfly_harfbuzz/flatten_svg_service'
require 'dragonfly_harfbuzz/markup_svg_service'
require 'dragonfly_harfbuzz/translate_service'

require 'dragonfly_harfbuzz/plugin'
require 'dragonfly_harfbuzz/version'

module DragonflyHarfbuzz
  class UnsupportedFormat < RuntimeError; end
  class UnsupportedOutputFormat < RuntimeError; end

  SUPPORTED_FORMATS = %w[otf ttf].freeze
  SUPPORTED_OUTPUT_FORMATS = %w[png svg pdf ps eps].freeze
end
