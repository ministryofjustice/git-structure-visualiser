# frozen_string_literal: true

module Gitgraphia
  class Inspector
    def initialize
      @reader = Gitgraphia::Reader.new
    end

    def find_branch_ancestry(start_commit)
      return [] unless start_commit
      start_commit = { type: 'commit', sha: start_commit } unless start_commit.is_a?(Hash)

      branch_parent_commit = reader.parents_of(start_commit[:sha]).first
      ancestry = find_branch_ancestry(branch_parent_commit)

      [start_commit].concat(ancestry)
    end

    private

    attr_reader :reader
  end
end
