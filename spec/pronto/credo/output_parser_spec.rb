require 'spec_helper'
require 'pathname'
require 'pronto/credo/output_parser'

RSpec.describe Pronto::Credo::OutputParser do
  let(:parser) { described_class.new(file, output) }
  let(:file) { 'web/channels/board_channel.ex' }
  let(:output) { File.read("#{Pathname.pwd}/spec/fixtures/credo_output.txt") }

  describe '#parse' do
    subject { parser.parse }
    it 'parses output' do
      expect(subject).to eq(
        [
          { line: 30,
            :column => nil,
            :level => :info,
            :message=>"Duplicate code found in web/models/list.ex:27 (mass: 16)."
          },
          { line: 181,
            :column => 11,
            :level => :info,
            :message => "There are spaces around operators most of the time, but not here."
          },
          { line: 47,
            :column => nil,
            :level => :info,
            :message => "There is no whitespace around parentheses/brackets most of the time, but here there is."
          }
        ]
      )
    end
  end
end
