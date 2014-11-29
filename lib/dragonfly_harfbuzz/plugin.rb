module DragonflyHarfbuzz
  class Plugin

    def call app, opts={}
      # app.add_processor :correct_metrics, Processors::CorrectMetrics.new
    end

  end
end

Dragonfly::App.register_plugin(:harfbuzz) { DragonflyHarfbuzz::Plugin.new }