require 'test_helper'

module DragonflyHarfbuzz
  describe Plugin do

    let(:app) { test_app.configure_with(:harfbuzz) }
    let(:font) { app.fetch_file(SAMPLES_DIR.join('Inconsolata.otf')) }

    # ---------------------------------------------------------------------
        
    describe 'processors' do
      # it 'adds #correct_metrics' do
      #   font.must_respond_to :correct_metrics
      # end
    end

  end
end