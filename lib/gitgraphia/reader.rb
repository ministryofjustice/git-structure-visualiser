# frozen_string_literal: true

module Gitgraphia
  class Reader
    def object_of(git_sha)
      `git cat-file -p #{git_sha}`.split("\n")
    end

    def tree_of(git_sha)
      object_of(git_sha)
        .select { |line| line =~ /^tree/ }
        .map { |line| line.gsub(/^tree /, '') }
        .first
    end

    def parents_of(git_sha)
      object_of(git_sha)
        .select { |line| line =~ /^parent/ }
        .map { |line| line.gsub(/^parent /, '') }
    end

    def tree_to_files(tree_sha)
      object_of(tree_sha)
        .map { |line| line.split(nil, 4) }
        .map { |line| { permissions: line[0], type: line[1], sha: line[2], name: line[3] } }
    end
  end
end
