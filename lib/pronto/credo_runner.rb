require 'pronto'
require 'pronto/credo/wrapper'

module Pronto
  class CredoRunner < Runner
    def initialize(_, _)
      super
    end

    def run
      return [] unless @patches

      @patches.select { |p| p.additions > 0 }
              .select { |p| elixir_file?(p.new_file_full_path) }
              .map { |p| inspect(p) }
              .flatten
              .compact
    end

    private

    def inspect(patch)
      offences = Credo::Wrapper.new(patch).lint
      messages = []

      offences.each do |offence|
        added_lines = patch.added_lines
        bad_lines =
          added_lines
            .select { |line| line.new_lineno == offence[:line] }

        if bad_lines == []
          bad_lines =
            added_lines
              .select { |line| close_to(line.new_lineno, offence[:line]) }
        end

        messages += bad_lines.map { |line| new_message(offence, line) }
      end

      messages
    end

    def new_message(offence, line)
      path = line.patch.delta.new_file[:path]
      # update the Line to have the correct line number
      # TODO it'd be great to have a real way to do this.
      rugged_line = line.line.clone
      rugged_line.instance_exec {
        @new_lineno = offence[:line]
      }
      new_line = line.clone
      new_line.line = rugged_line
      Message.new(path, new_line, offence[:level], offence[:message])
    end

    def elixir_file?(path)
      %w(.ex .exs).include?(File.extname(path))
    end

    def close_to(diff_line, offence_line)
      (diff_line - offence_line).abs < 2
    end
  end
end
