require 'pronto/credo/wrapper'
require 'pronto'

module Pronto
  class CredoRunner < Runner
    def run(patches, _)
      return [] unless patches

      offences = Swiftlint::Wrapper.new.lint

      patches.select { |p| p.additions > 0 }
        .select { |p| swift_file?(p.new_file_full_path) }
        .map { |p| inspect(p, offences) }
        .flatten
        .compact

    end

    private

    def inspect(patch, offences)
      messages = []
      offences_in_file = offences[patch.new_file_full_path.to_s]
      return unless offences_in_file

      offences_in_file.each do |offence|
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

    def swift_file?(path)
      %w(.swift).include?(File.extname(path))
    end
  end
end
