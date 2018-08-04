require 'shellwords'

module DragonflyHarfbuzz
  module Processors
    class HbView
      def call(content, str, options = {})
        options = options.each_with_object({}) { |(k, v), memo| memo[k.to_s] = v } # stringify keys
        unicodes = options.fetch('unicodes', nil)

        raise UnsupportedFormat unless SUPPORTED_FORMATS.include?(content.ext)

        format = options.fetch('format', 'svg').to_s

        raise UnsupportedOutputFormat unless SUPPORTED_OUTPUT_FORMATS.include?(format)

        flatten_svg = options.fetch('flatten_svg', false)
        markup_svg = options.fetch('markup_svg', flatten_svg)
        split_paths = options.fetch('split_paths', false)

        content.shell_update(ext: format) do |old_path, new_path|
          args = %W[
            --font-file=#{old_path}
            --output-file=#{new_path}
            --output-format=#{format}
          ]

          args << "--text='#{str}'" unless options.has_key?('unicodes')

          options.reject { |k, _| %w[format markup_svg flatten_svg split_paths].include?(k.to_s) }.each do |k, v|
            args << "--#{k.to_s.tr('_', '-')}=#{Shellwords.escape(v)}" if v.present?
          end

          "#{hb_view_command} #{args.join(' ')}"
        end

        content.meta['format'] = format
        content.ext = format

        if format =~ /svg/i
          content.update(MarkupSvgService.call((str || str_from_unicodes(unicodes)), content.data, split_paths: split_paths), 'name' => "temp.#{format}") if markup_svg
          content.update(FlattenSvgService.call(content.data), 'name' => "temp.#{format}") if flatten_svg
          content.update(DomAttrsService.call(content.data, options[:font_size], options[:margin]), 'name' => "temp.#{format}") if markup_svg
        end

        content
      end

      def update_url(attrs, str = '', options = {})
        format = options.fetch('format', 'svg').to_s
        attrs.ext = format
      end

      private

      def str_from_unicodes(unicodes)
        unicodes.split(",").map do |hexstring|
          begin
            Array(hexstring).pack("H*").force_encoding('utf-16be').encode('utf-8')
          rescue
            " "
          end
        end.join
      end

      def hb_view_command
        'hb-view'
      end
    end
  end
end
