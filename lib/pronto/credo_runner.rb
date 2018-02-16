require 'pronto'
require 'pronto/credo/wrapper'

module Pronto
  class CredoRunner < Runner
    def initialize(_, _)
      super
    end

    def run
      return [] unless @patches

      compile if ENV["PRONTO_CREDO_COMPILE"] == "1"

      @patches.select { |p| p.additions > 0 }
        .select { |p| elixir_file?(p.new_file_full_path) }
        .map { |p| inspect(p) }
        .flatten
        .compact
    end

    private

    def compile
      stdout_stderr, status = Open3.capture2e("mix deps.get && mix compile --force")
      if !status.success?
        $stderr.puts "Elixir compilation error(s):"
        $stderr.puts stdout_stderr
        raise "failed to compile"
      end
    end

    def inspect(patch)
      offences = Credo::Wrapper.new(patch).lint
      messages = []

      offences.each do |offence|
        messages += patch
          .added_lines
          .select { |line| line.new_lineno == offence[:line] }
          .map { |line| new_message(offence, line) }
      end

      messages.compact
    end

    def new_message(offence, line)
      path = line.patch.delta.new_file[:path]
      Message.new(path, line, offence[:level], offence[:message])
    end

    def elixir_file?(path)
      %w(.ex .exs).include?(File.extname(path))
    end
  end
end
