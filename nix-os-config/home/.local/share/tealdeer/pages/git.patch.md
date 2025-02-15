- Blank out repo files for worktree
`git checkout $(git commit-tree $(git hash-object -t tree /dev/null) < /dev/null)`
