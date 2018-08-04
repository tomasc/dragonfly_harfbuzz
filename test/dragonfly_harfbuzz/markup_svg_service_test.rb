require 'test_helper'

describe DragonflyHarfbuzz::MarkupSvgService do
  let(:app) { test_app.configure_with(:harfbuzz) }
  let(:processor) { DragonflyHarfbuzz::Processors::HbView.new }
  let(:content) { Dragonfly::Content.new(app, SAMPLES_DIR.join('sample.otf')) }
  let(:string) { 'ABC     def' }
  let(:svg) { processor.call(content, string).data }
  let(:result) { DragonflyHarfbuzz::MarkupSvgService.call(string, svg) }

  describe 'lines' do
    it { result.must_include "line=\"#{string}\" class=\"line\"" }
  end

  describe 'words' do
    it { result.must_include "word=\"ABC\" class=\"word\"" }
    it { result.must_include "word=\"def\" class=\"word\"" }
  end

  describe 'characters' do
    it { result.must_include "character=\"A\" class=\"character\"" }
    it { result.must_include "character=\"B\" class=\"character\"" }
    it { result.must_include "character=\"C\" class=\"character\"" }
    it { result.must_include "character=\"d\" class=\"character\"" }
    it { result.must_include "character=\"e\" class=\"character\"" }
    it { result.must_include "character=\"f\" class=\"character\"" }
  end
end
