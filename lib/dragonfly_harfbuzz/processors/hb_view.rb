require 'shellwords'

module DragonflyHarfbuzz
  module Processors
    class HbView

      def call font, str, opts={}
        format = opts.fetch(:format, :svg)
        markup_svg = opts.fetch(:markup_svg, false)

        font.shell_update(ext: format) do |old_path, new_path|
          args = %W(
            --font-file=#{old_path}
            --output-file=#{new_path}
            --output-format=#{format}
          )

          opts.reject{ |k,v| %w(format markup_svg).include?(k.to_s) }.each do |k, v|
            args << "--#{k.to_s.gsub('_', '-')}=#{Shellwords.escape(v)}"
          end

          "hb-view #{Shellwords.escape(str)} #{args.join(' ')}"
        end

        if format
          font.meta['format'] = format.to_s
          font.ext = format
        end

        font.update(DragonflyHarfbuzz::MarkupSvgService.call(str, font.data)) if markup_svg && format.to_sym == :svg
      end

      def update_url(attrs, args='', opts={})
        format = opts['format']
        attrs.ext = format if format
      end

    end
  end
end
