# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/spec'
require 'gitgraphia/inspector'

describe Gitgraphia::Inspector do
  # These are real commit SHAs on this repository from the `master` branch.
  # Using real hashes is unconventional, but git is immutable and I don't have to mock `git cat-file` this way.
  let(:root_commit_sha) { 'ab1527fbb47bbf110133a27f3a9043ba3a963062' }
  let(:child_of_root_commit_sha) { 'd102418484007c2ca572860977a0ac3327a5d7c8' }
  let(:merge_commit_sha) { '8dcc4e8f9da54ef5e8692642da2de15e5e78f233' }

  let(:inspector) { Gitgraphia::Inspector.new }

  describe '#find_branch_ancestry' do
    it 'walks from the given commit SHA to the root commit keeping to the first parent' do
      ancestry = inspector.find_branch_ancestry(merge_commit_sha)

      #  *   8dcc4e8 Merge pull request #1 from sldblog/human-readable-concept -- merge_commit_sha
      #  |\
      #  | * 8895913 Add GitHub workflow to run tests
      #  | * 883f2bb Add script describing the HEAD commit
      #  |/
      #  * d102418 Add the concept of the repository into the readme           -- child_of_root_commit_sha
      #  * ab1527f Initial commit                                              -- root_commit_sha

      _(ancestry).must_equal [
        { type: 'commit', sha: merge_commit_sha },
        { type: 'commit', sha: child_of_root_commit_sha },
        { type: 'commit', sha: root_commit_sha }
      ]
    end
  end
end
