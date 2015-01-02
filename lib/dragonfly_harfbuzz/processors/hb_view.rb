require 'shellwords'

module DragonflyHarfbuzz
  module Processors
    class HbView

      def call font, str, opts={}
        format = opts.fetch(:format, :svg)

        font.shell_update(ext: format) do |old_path, new_path|
          
          args = %W(
            --font-file=#{old_path}
            --output-file=#{new_path}
            --output-format=#{format}
          )

          opts.reject{ |k,v| k.to_sym == :format }.each do |k, v|
            args << "--#{k.to_s.gsub('_', '-')}=#{Shellwords.escape(v)}"
          end

          "hb-view #{Shellwords.escape(str)} #{args.join(' ')}"
        end
      end

    end
  end
end