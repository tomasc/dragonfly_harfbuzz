require 'test_helper'

module DragonflyHarfbuzz
  describe FlattenSvgService do
    let(:app) { test_app.configure_with(:harfbuzz) }
    let(:processor) { DragonflyHarfbuzz::Processors::HbView.new }
    let(:content) { Dragonfly::Content.new(app, SAMPLES_DIR.join('sample.otf')) }
    let(:string) { 'ABC     def' }
    let(:svg) { processor.call(content, string) }
    let(:call) { DragonflyHarfbuzz::FlattenSvgService.call(string, svg) }

    describe 'flatten_svg' do
      before { processor.call(content, string, flatten_svg: true) }

      describe 'lines' do
        it { content.data.must_include "line=\"#{string}\" class=\"line\"" }
      end

      describe 'words' do
        it { content.data.must_include '<g word="ABC" class="word">' }
        it { content.data.must_include '<g word="def" class="word">' }
      end

      describe 'characters' do
        it { content.data.must_include '<svg character="A" class="character"' }
        it { content.data.must_include '<svg character="B" class="character"' }
        it { content.data.must_include '<svg character="C" class="character"' }
        it { content.data.must_include '<svg character="d" class="character"' }
        it { content.data.must_include '<svg character="e" class="character"' }
        it { content.data.must_include '<svg character="f" class="character"' }
      end
    end
  end
end
