# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/spec'
require 'gitgraphia/cypher_formatter'

describe Gitgraphia::CypherFormatter do
  let(:formatter) { Gitgraphia::CypherFormatter.new }

  describe '#add_edge' do
    it 'appends a line representing a named edge between two git object nodes' do
      formatter.add_edge({ type: 'commit', sha: 'test' }, :has_parent, type: 'commit', sha: 'older')

      _(formatter.output).must_equal <<~EOF
        CREATE
        (_older:commit {sha: "older"}),
        (_test:commit {sha: "test"}),
        (_test)-[:has_parent]->(_older)
      EOF
    end

    it 'defines a node only once in the node list' do
      formatter.add_edge({ type: 'commit', sha: 'test' }, :has_parent, type: 'commit', sha: 'older')
      formatter.add_edge({ type: 'commit', sha: 'older' }, :has_parent, type: 'commit', sha: 'oldest')

      _(formatter.output).must_equal <<~EOF
        CREATE
        (_older:commit {sha: "older"}),
        (_oldest:commit {sha: "oldest"}),
        (_test:commit {sha: "test"}),
        (_test)-[:has_parent]->(_older),
        (_older)-[:has_parent]->(_oldest)
      EOF
    end
  end
end
