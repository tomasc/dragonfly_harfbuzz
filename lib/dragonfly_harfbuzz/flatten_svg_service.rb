require 'ox'

module DragonflyHarfbuzz
  class FlattenSvgService
    attr_accessor :ox_doc
    attr_accessor :svg

    def self.call(*args)
      new(*args).call
    end

    def initialize(svg)
      @svg = svg
      @ox_doc = Ox.parse(svg)
    end

    def call
      get_words.each do |word|
        characters_to_add = []

        get_characters_from_word(word).each do |character|
          symbol = get_symbol_for_character(character)
          characters_to_add << build_character_svg(character, symbol)
        end

        word.nodes.clear

        characters_to_add.each { |char| word << char }
      end

      lines = ox_doc.locate('g/g').select { |g| g[:class] == 'line' }

      add_lines_to_doc(lines)

      Ox.dump(ox_doc)
    end

    private

    def add_lines_to_doc(lines)
      ox_doc.nodes.clear
      lines.each { |line| ox_doc << line }
    end

    def get_symbols
      ox_doc.locate('defs/g/symbol')
    end

    def get_words
      ox_doc.locate('g/g/g')
    end

    def get_characters_from_word(word)
      word.locate('use')
    end

    def get_symbol_for_character(character)
      symbols = ox_doc.locate('defs/g/symbol')
      symbol_href = character.attributes[:"xlink:href"].delete('#')
      symbols.select { |s| s.attributes[:id] == symbol_href }.first
    end

    def build_character_svg(character, symbol)
      character_svg = Ox::Element.new('svg').tap do |prop|
        prop[:character] = character[:character]
        prop[:class] = 'character'
        prop[:overflow] = 'visible'
        prop[:x] = character[:x]
        prop[:y] = character[:y]
      end

      symbol.nodes.each do |path|
        character_svg << path
      end

      character_svg
    end
  end
end
