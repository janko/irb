# frozen_string_literal: true

require "stringio"
require_relative "nop"
require_relative "../pager"

module IRB
  # :stopdoc:

  module ExtendCommand
    class ShowCmds < Nop
      category "IRB"
      description "List all available commands and their description."

      def execute(*args)
        commands_info = IRB::ExtendCommandBundle.all_commands_info
        commands_grouped_by_categories = commands_info.group_by { |cmd| cmd[:category] }
        longest_cmd_name_length = commands_info.map { |c| c[:display_name].length }.max

        output = StringIO.new

        commands_grouped_by_categories.each do |category, cmds|
          output.puts Color.colorize(category, [:BOLD])

          cmds.each do |cmd|
            output.puts "  #{cmd[:display_name].to_s.ljust(longest_cmd_name_length)}    #{cmd[:description]}"
          end

          output.puts
        end

        helpers_info = IRB::HelperMethod.all_helper_methods_info

        unless helpers_info.empty?
          output.puts(Color.colorize("[Helper Methods]", [:BOLD]) + "\n\n")
        end

        helpers_grouped_by_categories = helpers_info.group_by { |cmd| cmd[:category] }
        longest_helper_name_length = helpers_info.map { |c| c[:display_name].length }.max

        helpers_grouped_by_categories.each do |category, helpers|
          output.puts Color.colorize(category, [:BOLD])

          helpers.each do |helper|
            output.puts "  #{helper[:display_name].to_s.ljust(longest_helper_name_length)}    #{helper[:description]}"
          end

          output.puts
        end

        Pager.page_content(output.string)
      end
    end
  end

  # :startdoc:
end
