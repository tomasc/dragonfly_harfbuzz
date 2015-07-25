require 'ox'

module DragonflyHarfbuzz
  class DomAttrsService < Struct.new :svg, :font_size, :margin

    def self.call *args
      self.new(*args).call
    end

    def call
      ox_doc[:'data-font-size'] = font_size if font_size.present?
      ox_doc[:'data-margin'] = margin if margin.present?

      Ox.dump(@ox_doc)
    end

    private # =============================================================

    def ox_doc
      @ox_doc ||= Ox.parse(svg)
    end

  end
end
