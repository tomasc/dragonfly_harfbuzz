require 'test_helper'

describe DragonflyHarfbuzz::Processors::HbView do
  let(:app) { test_app.configure_with(:harfbuzz) }
  let(:content) { Dragonfly::Content.new(app, SAMPLES_DIR.join('sample.otf')) }
  let(:processor) { DragonflyHarfbuzz::Processors::HbView.new }

  let(:string) { 'FOO' }

  DragonflyHarfbuzz::SUPPORTED_FORMATS.each do |format|
    describe format.to_s do
      let(:content) { app.fetch_file SAMPLES_DIR.join("sample.#{format}") }
      it { content.hb_view(string).ext.must_equal 'svg' }
      it { content.hb_view(string).mime_type.must_equal 'image/svg+xml' }
    end
  end

  DragonflyHarfbuzz::SUPPORTED_OUTPUT_FORMATS.each do |format|
    describe "output to #{format}" do
      let(:content) { app.fetch_file SAMPLES_DIR.join("sample.otf") }
      it { content.hb_view(string, format: format).ext.must_equal format }
      it { content.hb_view(string, format: format).mime_type.must_equal Rack::Mime.mime_type(".#{format}") }
    end
  end

  describe 'foreground' do
    before { processor.call(content, string, foreground: '#ff00ff') }
    it { content.data.must_include 'fill:rgb(100%,0%,100%);' }
  end

  describe 'markup_svg' do
    before { processor.call(content, string, markup_svg: true) }
    it { content.data.must_include "word=\"#{string}\"" }
    it { content.data.must_include 'character="F"' }
    it { content.data.must_include 'character="O"' }
    it { content.data.must_include 'character="O"' }
    it { content.data.must_include 'class="character"' }
    it { content.data.must_include 'class="word"' }
  end

  describe 'flatten_svg' do
    before { processor.call(content, string, flatten_svg: true) }
    it { content.data.wont_include '#glyph0-1' }
  end
end
