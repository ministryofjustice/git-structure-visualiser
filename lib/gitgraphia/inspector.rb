# frozen_string_literal: true

module Gitgraphia
  class Inspector
    def initialize
      @reader = Gitgraphia::Reader.new
    end

    def find_branch_ancestry(start_commit_sha)
      return [] unless start_commit_sha

      branch_parent_sha = reader.parents_of(start_commit_sha).first&.[](:sha)
      ancestry = find_branch_ancestry(branch_parent_sha)

      [start_commit_sha].concat(ancestry)
    end

    private

    attr_reader :reader
  end
end
