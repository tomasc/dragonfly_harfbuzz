require 'minitest_helper'

module DragonflyHarfbuzz
  describe FlattenSvgService do

    let(:app) { test_app.configure_with(:harfbuzz) }
    let(:processor) { DragonflyHarfbuzz::Processors::HbView.new }
    let(:font) { Dragonfly::Content.new(app, SAMPLES_DIR.join('Inconsolata.otf')) }
    let(:string) { 'A line with foo in it twice: foo' }
    let(:svg) { processor.call(font, string) }
    let(:call) { DragonflyHarfbuzz::FlattenSvgService.call(string, svg) }

    # ---------------------------------------------------------------------

    describe 'call' do
      it 'does something' do
        p svg
        p call
      end
    end

  end
end
