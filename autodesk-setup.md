# Notes for stuff I need whilst working @autodesk

## So I can use SSH keys rather than personal access tokens
- Submodules that have full HTTP paths, not relative paths, fail to update when I use SSH not access tokens
`git config --global url."git@git.autodesk.com:".insteadOf https://git.autodesk.com/`
