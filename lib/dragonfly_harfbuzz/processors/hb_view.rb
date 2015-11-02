require 'shellwords'

module DragonflyHarfbuzz
  module Processors
    class HbView

      def call font, str, opts={}
        format = opts.fetch(:format, :svg)
        flatten_svg = opts.fetch(:flatten_svg, false)
        markup_svg = opts.fetch(:markup_svg, flatten_svg)

        font.shell_update(ext: format) do |old_path, new_path|
          args = %W(
            --font-file=#{old_path}
            --output-file=#{new_path}
            --output-format=#{format}
          )

          opts.reject{ |k,v| %w(format markup_svg flatten_svg).include?(k.to_s) }.each do |k, v|
            args << "--#{k.to_s.gsub('_', '-')}=#{Shellwords.escape(v)}"
          end

          "hb-view #{Shellwords.escape(str)} #{args.join(' ')}"
        end

        p font

        if format
          font.meta['format'] = format.to_s
          font.ext = format
        end

        if format.to_s =~ /svg/i
          font.update( DragonflyHarfbuzz::MarkupSvgService.call(str, font.data) ) if markup_svg
          font.update( DragonflyHarfbuzz::FlattenSvgService.call(font.data) ) if flatten_svg
          font.update( DragonflyHarfbuzz::DomAttrsService.call(font.data, opts[:font_size], opts[:margin]) )
        end
      end

      def update_url(attrs, args='', opts={})
        format = opts['format']
        attrs.ext = format if format
      end

    end
  end
end
