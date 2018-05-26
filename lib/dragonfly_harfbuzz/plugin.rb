require 'dragonfly_harfbuzz/processors/hb_view'

module DragonflyHarfbuzz
  class Plugin
    def call(app, options={})
      app.add_processor :hb_view, Processors::HbView.new

      app.add_mime_type 'otf', 'font/otf'
    end
  end
end

Dragonfly::App.register_plugin(:harfbuzz) { DragonflyHarfbuzz::Plugin.new }
