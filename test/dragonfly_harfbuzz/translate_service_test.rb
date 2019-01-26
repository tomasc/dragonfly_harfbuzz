require 'test_helper'

describe DragonflyHarfbuzz::TranslateService do
  let(:app) { test_app.configure_with(:harfbuzz) }
  let(:processor) { DragonflyHarfbuzz::Processors::HbView.new }
  let(:content) { Dragonfly::Content.new(app, SAMPLES_DIR.join('sample.otf')) }
  let(:string) { 'A' }
  let(:svg) { processor.call(content, string).data }
  let(:font_info) { analyser.call(content) }
  let(:result) { DragonflyHarfbuzz::TranslateService.call(svg, x: 100, y: 100) }

  it { result.must_include 'x="116.0"' }
  it { result.must_include 'y="329.5"' }
end
