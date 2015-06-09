require 'dragonfly_harfbuzz/processors/hb_view'

module DragonflyHarfbuzz
  class Plugin

    def call app, opts={}
      app.add_processor :hb_view, Processors::HbView.new
    end

  end
end

Dragonfly::App.register_plugin(:harfbuzz) { DragonflyHarfbuzz::Plugin.new }
