require 'test_helper'

module DragonflyHarfbuzz
  describe Plugin do

    let(:app) { test_app.configure_with(:harfbuzz) }
    let(:font) { app.fetch_file(SAMPLES_DIR.join('Inconsolata.otf')) }

    # ---------------------------------------------------------------------

    describe 'processors' do
      it 'adds #hb_view' do
        font.must_respond_to :hb_view
      end
    end

  end
end
