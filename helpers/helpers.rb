# encoding: utf-8

module Sinatra
  module Mimsy
    module Helpers

      def h(text)
        Rack::Utils.escape_html(text)
      end

      def number_with_delimiter(number, default_options = {})
        options = {
          :delimiter => ','
        }.merge(default_options)
        number.to_s.reverse.gsub(/(\d{3}(?=(\d)))/, "\\1#{options[:delimiter]}").reverse
      end

      def cycle
        %w{even odd}[@_cycle = ((@_cycle || -1) + 1) % 2]
      end

      def reset_cycle
        @_cycle = nil
      end

      def output_dir(file)
        File.join(ENV['PWD'], 'outputs', File.basename(File.dirname(file)))
      end

    end
  end
end