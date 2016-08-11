require 'shellwords'

module DragonflyHarfbuzz
  module Processors
    class HbView
      def call(content, str, opts = {})
        format = opts.fetch(:format, :svg)
        flatten_svg = opts.fetch(:flatten_svg, false)
        markup_svg = opts.fetch(:markup_svg, flatten_svg)
        split_paths = opts.fetch(:split_paths, true)

        content.shell_update(ext: format) do |old_path, new_path|
          args = %W(
            --font-file=#{old_path}
            --output-file=#{new_path}
            --output-format=#{format}
          )

          opts.reject { |k, _v| %w(format markup_svg flatten_svg split_paths).include?(k.to_s) }.each do |k, v|
            args << "--#{k.to_s.tr('_', '-')}=#{Shellwords.escape(v)}"
          end

          "hb-view #{Shellwords.escape(str)} #{args.join(' ')}"
        end

        if format
          content.meta['format'] = format.to_s
          content.ext = format
        end

        if format.to_s =~ /svg/i
          content.update(DragonflyHarfbuzz::MarkupSvgService.call(str, content.data, split_paths: split_paths)) if markup_svg
          content.update(DragonflyHarfbuzz::FlattenSvgService.call(content.data)) if flatten_svg
          content.update(DragonflyHarfbuzz::DomAttrsService.call(content.data, opts[:font_size], opts[:margin]))
        end

        content
      end

      # ---------------------------------------------------------------------

      def update_url(attrs, _args = '', opts = {})
        format = opts['format']
        attrs.ext = format if format
      end
    end
  end
end
