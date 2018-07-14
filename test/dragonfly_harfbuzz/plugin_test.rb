require 'test_helper'

describe DragonflyHarfbuzz::Plugin do
  let(:app) { test_app.configure_with(:harfbuzz) }
  let(:content) { app.fetch_file(SAMPLES_DIR.join('sample.otf')) }

  describe 'processors' do
    it { content.must_respond_to :hb_view }
  end
end
