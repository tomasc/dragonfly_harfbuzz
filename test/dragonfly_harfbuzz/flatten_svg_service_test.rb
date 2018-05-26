require 'test_helper'

module DragonflyHarfbuzz
  describe FlattenSvgService do
    let(:app) { test_app.configure_with(:harfbuzz) }
    let(:processor) { DragonflyHarfbuzz::Processors::HbView.new }
    let(:content) { Dragonfly::Content.new(app, SAMPLES_DIR.join('sample.otf')) }
    let(:string) { 'foo     foo' }
    let(:svg) { processor.call(content, string) }
    let(:call) { DragonflyHarfbuzz::FlattenSvgService.call(string, svg) }

    let(:f_markup) { '<svg character="f" class="character" overflow="visible" x="1552" y="229.504">' }

    describe 'flatten_svg' do
      before { processor.call(content, string, flatten_svg: true) }
      it { content.data.sub(f_markup, '').wont_include f_markup }
    end
  end
end
