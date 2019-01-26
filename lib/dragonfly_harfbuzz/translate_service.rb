require 'ox'

module DragonflyHarfbuzz
  class TranslateService
    attr_accessor :ox_doc
    attr_accessor :svg
    attr_accessor :x
    attr_accessor :y

    def self.call(*args)
      new(*args).call
    end

    def initialize(svg, x: 0, y: 0)
      @svg = svg
      @x = x.to_f
      @y = y.to_f
      @ox_doc = Ox.parse(svg)
    end

    def call
      use_definitions.each do |use_definition|
        use_definition[:x] = use_definition[:x].to_f + x
        use_definition[:y] = use_definition[:y].to_f + y
      end

      Ox.dump(ox_doc)
    end

    private

    def use_definitions
      ox_doc.locate('svg/g/g/use[@xlink:href]')
    end
  end
end
