# Defined in /var/folders/9g/2zbs6ph55vb5bbtfdtn0pdk40000gn/T//fish.kx6rIF/dot2png.fish @ line 1
function dot2png --argument file
	dot -Tpng $file.gv -o $file.png
  open $file.png
end
