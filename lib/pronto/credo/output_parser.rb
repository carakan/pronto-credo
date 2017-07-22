module Pronto
  module Credo
    class OutputParser
      attr_reader :output, :file

      def initialize(file, output)
        @file = file
        @output = output
      end

      def type_warnings
        @type_warnings ||= if ENV["PRONTO_CREDO_STRICT"] == "1"
          { 'R' => :warning,
            'W' => :warning,
            'C' => :warning,
            'D' => :warning,
            'F' => :warning,
            'A' => :warning
          }
        else
          { 'R' => :info,
            'W' => :warning,
            'C' => :info,
            'D' => :info,
            'F' => :info,
            'A' => :info
          }
        end
      end

      def parse
        output.lines.map do |line|
          line_parts = line.split(':')
          next unless file.start_with?(line_parts[0])
          offence_in_line = line_parts[1]
          column_line = nil
          if line_parts[2].to_i == 0
            offence_level = type_warnings[line_parts[2].strip]
            offence_message = line_parts[3..-1].join(':').strip
          else
            offence_level = type_warnings[line_parts[3].strip]
            column_line = line_parts[2].to_i
            offence_message = line_parts[4..-1].join(':').strip
          end
          {
            line: offence_in_line.to_i,
            column: column_line,
            level: offence_level,
            message: offence_message
          }
        end.compact
      end
    end
  end
end
