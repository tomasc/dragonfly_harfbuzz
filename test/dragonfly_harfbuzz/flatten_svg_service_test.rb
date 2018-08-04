require 'test_helper'

describe DragonflyHarfbuzz::FlattenSvgService do
  let(:app) { test_app.configure_with(:harfbuzz) }
  let(:processor) { DragonflyHarfbuzz::Processors::HbView.new }
  let(:content) { Dragonfly::Content.new(app, SAMPLES_DIR.join('sample.otf')) }
  let(:string) { 'ABC     def' }
  let(:svg) { processor.call(content, string, markup_svg: true, flatten_svg: false).data }
  let(:result) { DragonflyHarfbuzz::FlattenSvgService.call(svg) }

  describe 'lines' do
    it { result.must_include "line=\"#{string}\" class=\"line\"" }
  end

  describe 'words' do
    it { result.must_include '<g word="ABC" class="word">' }
    it { result.must_include '<g word="def" class="word">' }
  end

  describe 'characters' do
    it { result.must_include '<svg character="A" class="character"' }
    it { result.must_include '<svg character="B" class="character"' }
    it { result.must_include '<svg character="C" class="character"' }
    it { result.must_include '<svg character="d" class="character"' }
    it { result.must_include '<svg character="e" class="character"' }
    it { result.must_include '<svg character="f" class="character"' }
  end
end
