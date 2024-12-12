# Defined in /var/folders/9g/2zbs6ph55vb5bbtfdtn0pdk40000gn/T//fish.cLpgua/cleanup-branches.fish @ line 1
function cleanup-branches
	git delete-merged-branches
  git fetch --prune --prune-tags
end
