require 'ox'
require 'savage'

module DragonflyHarfbuzz
  class MarkupSvgService

    def self.call *args
      self.new(*args).call
    end

    def initialize text, svg
      @text = text
      @svg = svg
      @ox_doc = Ox.parse(@svg)
    end

    def call
      split_paths

      lines.each_with_index do |line, index|
        line_group = @ox_doc.locate("svg/g/g[#{index}]").first
        line_group[:line] = line
        line_group[:class] = "line"
        word_groups = []

        words_in_line(line).each do |word|
          word_groups << marked_up_word(word, line, line_group)
        end

        line_group.nodes.clear

        word_groups.each { |wg| line_group << wg }
      end

      Ox.dump(@ox_doc)
    end

    private # =============================================================

    # TODO: fix issues with negative paths ('O', 'd', etc.)
    #
    def split_paths
      symbols = @ox_doc.locate("svg/defs/g/symbol")
      symbols.each do |symbol|
        path = symbol.nodes.first
        parsed_path = Savage::Parser.parse(path[:d])
        subpath_elements = []

        parsed_path.subpaths.each do |subpath|
          path_element = Ox::Element.new('path').tap { |prop| prop[:d] = subpath.to_command }
          subpath_elements.push path_element
        end

        symbol.nodes.clear
        subpath_elements.each { |path| symbol << path }
      end
    end

    def lines
      @text.split(/\n+/)
    end

    def words_in_line line
      line.split(/\s+/)
    end

    def marked_up_characters characters, word
      characters.each do |character|
        index = characters.index(character)
        character[:character] = word[index]
        character[:class] = "character"
      end
    end

    def marked_up_word word, line, line_group
      word_group = Ox::Element.new('g').tap do |prop|
        prop[:word] = word
        prop[:class] = "word"
      end

      index_of_first_character = line.index(word)
      index_of_last_character = (index_of_first_character + word.length) - 1

      characters = line_group.locate("use")[index_of_first_character..index_of_last_character]

      marked_up_characters(characters, word).each do |char|
        word_group << char
      end

      word_group
    end

  end
end
