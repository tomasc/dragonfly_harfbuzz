require 'minitest_helper'

module DragonflyHarfbuzz
  module Processors
    describe HbView do

      let(:app) { test_app.configure_with(:harfbuzz) }
      let(:processor) { DragonflyHarfbuzz::Processors::HbView.new }
      let(:font) { Dragonfly::Content.new(app, SAMPLES_DIR.join('Inconsolata.otf')) }
      let(:string) { 'FOO' }

      it 'renders SVG by default' do
        processor.call(font, string)
        font.meta['format'].must_equal 'svg'
      end

      describe 'options' do
        it 'passes options to command line ' do
          processor.call(font, string, { foreground: '#ff00ff' })
          font.data.must_include 'fill:rgb(100%,0%,100%);'
        end

        it 'supports :markup_svg' do
          processor.call(font, string, { markup_svg: true })
          font.data.must_include "word=\"#{string}\""

          font.data.must_include 'character="F"'
          font.data.must_include 'character="O"'
          font.data.must_include 'character="O"'

          font.data.must_include 'class="character"'
          font.data.must_include 'class="word"'
        end
      end

    end
  end
end
