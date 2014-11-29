require 'test_helper'

module DragonflyHarfbuzz
  module Processors
    describe HbView do

      let(:app) { test_app.configure_with(:harfbuzz) }
      let(:processor) { DragonflyHarfbuzz::Processors::HbView.new }
      let(:font) { Dragonfly::Content.new(app, SAMPLES_DIR.join('Inconsolata.otf')) }

      it 'renders SVG by default' do
        processor.call(font, 'FOO').path.split('.').last.must_equal 'svg'
      end

      describe 'options' do
        it 'passes options to command line ' do
          processor.call(font, 'FOO', :svg, { foreground: '#ff00ff' }).data.must_include 'fill:rgb(100%,0%,100%);'
        end
      end

    end
  end
end
