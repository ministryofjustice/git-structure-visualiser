# frozen_string_literal: true

require 'set'

module Gitgraphia
  class CypherFormatter
    def initialize
      @nodes = Set.new
      @lines = []
    end

    def add_edge(from, label, to)
      nodes << full_node(from)
      nodes << full_node(to)
      lines << %(#{short_node(from)}-[:#{label}]->#{short_node(to)})
    end

    def output
      "CREATE\n" + nodes.sort.concat(lines).join(",\n") + "\n"
    end

    private

    attr_reader :nodes, :lines

    def node_alias(git_object)
      '_' + git_object[:sha]
    end

    def short_node(git_object)
      type = git_object[:type]
      id = node_alias(git_object)
      "(#{id})"
    end

    def full_node(git_object)
      type = git_object[:type]
      id = node_alias(git_object)
      "(#{id}:#{type} {#{properties(git_object)}})"
    end

    def properties(git_object)
      git_object.reject { |key, _| key == :type }.map { |key, value| %(#{key}: "#{value}") }.join(', ')
    end
  end
end
