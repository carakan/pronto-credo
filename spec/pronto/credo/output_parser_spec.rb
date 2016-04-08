require 'spec_helper'
require 'pathname'
require 'pronto/credo/output_parser'

RSpec.describe Pronto::Credo::OutputParser do
  let(:parser) { described_class.new }

  describe '#parse' do
    subject { parser.parse(output) }

    let(:output) do
      File.read("#{Pathname.pwd}/spec/fixtures/credo_output.txt")
    end

    it 'parses output' do
      expect(subject).to eq(
        '/Users/andrius/work/ios/TestApp/Views/MyView.swift' => [
          {
            line: 1,
            column: 7,
            level: :warning,
            message: 'Colons should be next to the identifier when specifying a type.',
            rule: 'colon'
          },
          {
            line: 5,
            column: 9,
            level: :error,
            message: "Variable name should start with a lowercase character 'name'",
            rule: 'variable_name'
          },
          {
            line: 43,
            column: nil,
            level: :warning,
            message: 'Lines should not have trailing whitespace.',
            rule: 'trailing_whitespace'
          }
        ]
      )
    end

    context 'trailing whitespace' do
      let(:output) do
        '/Users/andrius/work/ios/TestApp/MyView.swift:43: warning: Trailing Whitespace Violation: Lines should not have trailing whitespace. (trailing_whitespace)'
      end

      it 'parses output' do
        expect(subject).to eq(
          '/Users/andrius/work/ios/TestApp/MyView.swift' => [
            {
              line: 43,
              column: nil,
              level: :warning,
              message: 'Lines should not have trailing whitespace',
              rule: 'trailing_whitespace'
            }
          ]
        )
      end
    end
  end
end
