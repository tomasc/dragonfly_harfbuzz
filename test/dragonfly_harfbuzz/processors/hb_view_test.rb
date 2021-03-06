require 'test_helper'

describe DragonflyHarfbuzz::Processors::HbView do
  let(:app) { test_app.configure_with(:harfbuzz) }
  let(:content) { Dragonfly::Content.new(app, SAMPLES_DIR.join('sample.otf')) }
  let(:processor) { DragonflyHarfbuzz::Processors::HbView.new }

  let(:string) { "F'OO" }

  describe 'SUPPORTED_FORMATS' do
    DragonflyHarfbuzz::SUPPORTED_FORMATS.each do |format|
      unless File.exist?(SAMPLES_DIR.join("sample.#{format}"))
        it(format) { skip "sample.#{format} does not exist, skipping" }
        next
      end

      let(:content) { app.fetch_file SAMPLES_DIR.join("sample.#{format}") }

      DragonflyHarfbuzz::SUPPORTED_OUTPUT_FORMATS.each do |output_format|
        it("#{format} to #{output_format}") do
          result = content.hb_view(string, format: output_format)
          result.ext.must_equal output_format
          result.mime_type.must_equal Rack::Mime.mime_type(".#{output_format}")
          result.size.must_be :>, 0
          result.tempfile.path.must_match /\.#{output_format}\z/
        end
      end
    end
  end

  describe 'foreground' do
    before { processor.call(content, string, foreground: '#ff00ff') }
    it { content.data.must_include 'fill:rgb(100%,0%,100%);' }
  end

  describe 'translate_x' do
    let(:string) { 'A' }
    before { processor.call(content, string, translate: { x: 100 }) }
    it { content.data.must_include 'x="116.0"' }
  end

  describe 'translate_y' do
    let(:string) { 'A' }
    before { processor.call(content, string, translate: { y: 100 }) }
    it { content.data.must_include 'y="329.5"' }
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

  describe 'str as unicodes' do
    before { processor.call(content, nil, unicodes: '0042,0043', flatten_svg: true) }
    it { content.data.must_include '<svg character="B" class="character"' }
    it { content.data.must_include '<svg character="C" class="character"' }
  end
end
