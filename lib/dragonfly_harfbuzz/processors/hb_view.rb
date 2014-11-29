require 'shellwords'

module DragonflyHarfbuzz
  module Processors
    class HbView

      def call font, str, format=:svg, opts={}
        font.shell_update(ext: format) do |old_path, new_path|
          
          args = %W(
            --font-file=#{old_path}
            --output-file=#{new_path}
            --output-format=#{format}
          )

          opts.each do |k, v|
            args << "--#{k.to_s.gsub('_', '-')}=#{Shellwords.escape(v)}"
          end

          "hb-view #{Shellwords.escape(str)} #{args.join(' ')}"
        end
      end

    end
  end
end