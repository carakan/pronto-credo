require 'open3'
require_relative 'output_parser'

module Pronto
  module Credo
    class Wrapper
      def lint
        stdout, stderr, _ = Open3.capture3(swiftlint_executable)
        puts "WARN: pronto-credo: #{stderr}" if stderr && stderr.size > 0
        return {} if stdout.nil? || stdout == 0
        OutputParser.new.parse(stdout)
      end

      private

      def credo_executable
        ENV['PRONTO_CREDO_PATH'] || 'mix credo --format=flycheck --stdin'
      end
    end
  end
end
