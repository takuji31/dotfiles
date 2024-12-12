# Defined in /var/folders/9g/2zbs6ph55vb5bbtfdtn0pdk40000gn/T//fish.L22O2F/days-link-robolectric-properties.fish @ line 2
function days-link-robolectric-properties
	set -l prop_path (realpath ./)
	for test_dir in (find . -type d | grep -E src/test\$)
    set -l test_realpath (realpath $test_dir)
    set -l link_path (realpath --relative-to=$test_realpath $prop_path)
    echo $link_path
  end
end
