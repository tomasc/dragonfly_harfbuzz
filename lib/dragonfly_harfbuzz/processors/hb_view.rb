require 'shellwords'

module DragonflyHarfbuzz
  module Processors
    class HbView

      def call content, str, opts={}
        format = opts.fetch(:format, :svg)
        flatten_svg = opts.fetch(:flatten_svg, false)
        markup_svg = opts.fetch(:markup_svg, flatten_svg)

        content.shell_update(ext: format) do |old_path, new_path|
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

        if format
          content.meta['format'] = format.to_s
          content.ext = format
        end

        if format.to_s =~ /svg/i
          content.update( DragonflyHarfbuzz::MarkupSvgService.call(str, content.data) ) if markup_svg
          content.update( DragonflyHarfbuzz::FlattenSvgService.call(content.data) ) if flatten_svg
          content.update( DragonflyHarfbuzz::DomAttrsService.call(content.data, opts[:font_size], opts[:margin]) )
        end

        content
      end

      # ---------------------------------------------------------------------

      def update_url(attrs, args='', opts={})
        format = opts['format']
        attrs.ext = format if format
      end

    end
  end
end
