require 'ox'
require 'savage'

module DragonflyHarfbuzz
  class MarkupSvgService
    attr_accessor :ox_doc
    attr_accessor :text
    attr_accessor :options
    attr_accessor :svg

    def self.call(*args)
      new(*args).call
    end

    def initialize(text, svg, options = {})
      @text = text
      @svg = svg
      @ox_doc = Ox.parse(svg)
      @options = options
    end

    def call
      split_paths if split_paths?

      lines.each_with_index do |line, index|
        line_group = ox_doc.locate("svg/g/g[#{index}]").first
        line_group[:line] = line
        line_group[:class] = 'line'

        word_groups = []
        words_in_line(line).each_with_index do |word, word_index|
          next if word =~ /\s+/
          word_groups << marked_up_word(word, word_index, line, line_group)
        end

        line_group.nodes.clear

        word_groups.each { |wg| line_group << wg }
      end

      Ox.dump(ox_doc)
    end

    private

    def lines
      text.split(/\n+/)
    end

    def words_in_line(line)
      line.split(/(\s+)/)
    end

    def split_paths?
      options.fetch(:split_paths, true)
    end

    # FIXME: fix issues with negative paths ('O', 'd', etc.)
    def split_paths
      symbols = ox_doc.locate('svg/defs/g/symbol')
      symbols.each do |symbol|
        path = symbol.nodes.first
        parsed_path = Savage::Parser.parse(path[:d])
        subpath_elements = []

        parsed_path.subpaths.each do |subpath|
          path_element = Ox::Element.new('path').tap { |prop| prop[:d] = subpath.to_command }
          subpath_elements.push path_element
        end

        symbol.nodes.clear
        subpath_elements.each { |pth| symbol << pth }
      end
    end

    def marked_up_word(word, word_index, line, line_group)
      word_group = Ox::Element.new('g').tap do |prop|
        prop[:word] = word
        prop[:class] = 'word'
      end

      previous_words = words_in_line(line)[0...word_index]
      index_offset = previous_words.join.length

      index_of_first_character = index_offset + 0
      index_of_last_character = index_offset + word.length - 1

      characters = line_group.locate('use')[index_of_first_character..index_of_last_character]

      marked_up_characters(characters, word).each do |char|
        word_group << char
      end

      word_group
    end

    def marked_up_characters(characters, word)
      characters.each do |character|
        index = characters.index(character)
        character[:character] = word[index]
        character[:class] = 'character'
      end
    end
  end
end
