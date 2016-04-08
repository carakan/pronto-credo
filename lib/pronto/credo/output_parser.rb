module Pronto
  module Credo
    class OutputParser
      attr_reader :output, :file

      def initialize(file, output)
        @file = file
        @output = output
      end

      def parse
        output.lines.map do |line|
          next unless line.start_with?(file)
          line_parts = line.split(':')
          offence_in_line = line_parts[1]
          if line_parts[2].to_i == 0
            offence_level = line_parts[2].strip
          else
            offence_level = line_parts[3].strip
          end
          offence_rule = line[/\[.*?\]/].gsub('[', '').gsub(']', '')
          index_of_offence_rule = line.index(offence_rule)
          offence_message = line[index_of_offence_rule + offence_rule.size + 2..line.size]
          {
            'line' => offence_in_line.to_i,
            'level' => offence_level,
            'rule' => offence_rule,
            'message' => offence_message
          }
        end.compact
      end
    end
  end
end
