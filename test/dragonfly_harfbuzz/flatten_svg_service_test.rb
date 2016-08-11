require 'minitest_helper'

module DragonflyHarfbuzz
  describe FlattenSvgService do
    let(:app) { test_app.configure_with(:harfbuzz) }
    let(:processor) { DragonflyHarfbuzz::Processors::HbView.new }
    let(:font) { Dragonfly::Content.new(app, SAMPLES_DIR.join('Inconsolata.otf')) }
    let(:string) { 'foo     foo' }
    let(:svg) { processor.call(font, string) }
    let(:call) { DragonflyHarfbuzz::FlattenSvgService.call(string, svg) }

    let(:f_markup) { '<svg character="f" class="character" overflow="visible" x="1552" y="229.504">' }

    it 'supports :flatten_svg' do
      processor.call(font, string, flatten_svg: true)
      font.data.sub(f_markup, '').wont_include f_markup
    end
  end
end
