require 'open3'
require_relative 'output_parser'

module Pronto
  module Credo
    class Wrapper
      attr_reader :patch

      def initialize(patch)
        @patch = patch
      end

      def lint
        return [] if patch.nil?
        path = patch.delta.new_file[:path]
        stdout, stderr, _ = Open3.capture3(credo_executable(path))
        puts "WARN: pronto-credo: #{stderr}" if stderr && !stderr.empty?
        return {} if stdout.nil? || stdout.empty?
        OutputParser.new(path, stdout).parse
      end

      private

      def credo_executable(path)
        "mix credo --strict --format=flycheck #{path}"
      end
    end
  end
end
