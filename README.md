# gitgraphia

## Concept

`git` commits store snapshots of the entire filesystem under the repository.

The root commit of this repository has:

```
$ git cat-file -p ab1527fbb47bbf110133a27f3a9043ba3a963062 | grep tree
tree 82e3a754b6a0fcb238b03c0e47d05219fbf9cf89
```

This tree contains a single file:

```
$ git cat-file -p 82e3a754b6a0fcb238b03c0e47d05219fbf9cf89
100644 blob e69de29bb2d1d6434b8b29ae775ad8c2e48c5391	.gitignore
```

A new commit will contain a reference to its (potentially many) `parent`s and its own `tree`.

In git, _everything_ is hashed, meaning

- files that do not change will be referred by the same hash
- trees that do not change will be referred by the same hash
- a change in a file will show up in its tree's hash, traverse up to the root tree hash and then the commit hash

The aim of this tool is to visualise how changes ripple through `blob`s, `tree`s and `commit`s.
