# Defined in /var/folders/9g/2zbs6ph55vb5bbtfdtn0pdk40000gn/T//fish.7nk1CZ/create-robolectric-symlink.fish @ line 2
function create-robolectric-symlink
  set -l dir (pwd)
  set -l excludes build buildSrc gradle fastlane
  set -l children (ls)
  for child in $children
    cd $dir
    if not contains $child $excludes
      if test -d $child
        cd $child
        mkdir -p src/test/resources/
        cd src/test/resources
        ln -s ../../../../robolectric.properties
      end
    end
  end
  cd $dir
end
